import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class ResultSetPrinter
{
    public static void main(String[] args)
    {
        try (
                Connection connection = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/SCHOOL", "enigma", "");
                Statement statement = connection.createStatement()
        )
        {
            ResultSet resultSet = statement.executeQuery(
                    "SELECT * FROM instructor");
            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

            ResultSetPrinter resultSetPrinter = new ResultSetPrinter();
            resultSetPrinter.printResultSetAsTabular(resultSet, resultSetMetaData, 2);

        } catch (SQLException sqlException)
        {
            sqlException.printStackTrace();
        }
    }

    public void printResultSetAsTabular(ResultSet resultSet, ResultSetMetaData resultSetMetaData, int spaceNum)
            throws SQLException
    {
        int columnCount = resultSetMetaData.getColumnCount();
        LinkedHashMap<String, Integer> columnNameColumnDisplaySizeMap = new LinkedHashMap<>();

        for (int i = 1; i <= columnCount; i++)
        {
            columnNameColumnDisplaySizeMap.put(resultSetMetaData.getColumnName(i),
                    resultSetMetaData.getColumnDisplaySize(i));
        }

        for (Map.Entry<String, Integer> entry : columnNameColumnDisplaySizeMap.entrySet())
        {
            String formatString = "%-" + (entry.getValue() + spaceNum) + "s";
            String formattedColumn = String.format(formatString, entry.getKey());
            System.out.print(formattedColumn);
        }

        System.out.println();

        while (resultSet.next())
        {
            for (int i = 1; i <= columnCount; i++)
            {
                String formatString = "%-" + (resultSetMetaData.getColumnDisplaySize(i) + spaceNum) + "s";
                String colContent = resultSet.getString(i);
                String formattedString = String.format(formatString, colContent);
                System.out.print(formattedString);
            }
            System.out.println();
        }
    }
}
