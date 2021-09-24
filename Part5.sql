-- Coder: Enigma Zhang --

USE SCHOOL;

-- 5.2 --
-- See ResultSetPrinter.java --

-- 5.3 --
-- See PrerequisitesFinder.java --

-- 5.4 --
-- The constraints can be explained as for one timeslot there is only one section, since for one section there is only
-- one timeslot, so their relationship is one vs one.
CREATE TRIGGER instructor_constraint_teach
    BEFORE INSERT
    ON teaches
    FOR EACH ROW
BEGIN
    IF (EXISTS(
            SELECT time_slot_id
            FROM section
            WHERE time_slot_id IN
                  (SELECT time_slot_id
                   FROM teaches
                            NATURAL JOIN section
                   WHERE ID = NEW.ID)
              AND time_slot_id IN
                  (SELECT time_slot_id
                   FROM section
                   WHERE section.sec_id = NEW.sec_id
                     AND section.course_id = NEW.course_id
                     AND section.semester = NEW.semester
                     AND section.year = NEW.year)
        )
        )
    THEN
        SIGNAL SQLSTATE '20000' SET MESSAGE_TEXT = 'An instructor cannot teach two different sections in a semester
            in the same time slot.';
    END IF;
END;

CREATE TRIGGER instructor_constraint_section
    BEFORE INSERT
    ON section
    FOR EACH ROW
    IF (
            NEW.time_slot_id IN (
            SELECT time_slot_id
            FROM teaches
                     NATURAL JOIN section
            WHERE ID IN
                  (
                      SELECT ID
                      FROM teaches
                               NATURAL JOIN section
                      WHERE sec_id = NEW.sec_id
                        AND course_id = NEW.course_id
                        AND semester = NEW.semester
                        AND year = NEW.year)
        )
        )
    THEN
        SIGNAL SQLSTATE '20000' SET MESSAGE_TEXT = 'An instructor cannot teach two different sections in a semester
            in the same time slot.';
    END IF;

