import java.sql.*;
import java.util.*;

public class PrerequisitesFinder
{
    public static void main(String[] args)
    {
        try (
                Connection connection = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/SCHOOL", "enigma", "");
                PreparedStatement preparedStatement = connection.prepareStatement(
                        "SELECT prereq_id FROM prereq WHERE course_id = ?");
        )
        {
            Scanner scanner = new Scanner(System.in);
            String course_id = scanner.next();
            PrerequisitesFinder prerequisitesFinder = new PrerequisitesFinder();
            for (String s : prerequisitesFinder.findPrerequisites(preparedStatement, course_id)){
                System.out.println(s);
            }

        } catch (SQLException sqlException)
        {
            sqlException.printStackTrace();
        }
    }

    public HashSet<String> findPrerequisites(PreparedStatement statement, String courseId) throws SQLException{
        HashSet<String> appendCourseIdSet = new HashSet<>();
        HashSet<String> allCourseIdSet = new HashSet<>();
        int oldSetSize = -1;
        appendCourseIdSet.add(courseId);

        while (allCourseIdSet.size() != oldSetSize){
            oldSetSize = allCourseIdSet.size();
            HashSet<String> tempCourseIdSet = new HashSet<>();
            for (String course_id : appendCourseIdSet){
                statement.setString(1, course_id);
                ResultSet prereqResultSet = statement.executeQuery();
                while (prereqResultSet.next())
                {
                    tempCourseIdSet.add(prereqResultSet.getString("prereq_id"));
                }
            }
            allCourseIdSet.clear();
            allCourseIdSet.addAll(tempCourseIdSet);
        }

        return allCourseIdSet;
    }
}
