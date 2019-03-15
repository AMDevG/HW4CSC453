-- WRITE 3 TRIGGERS 
-- MAINTAIN VALUE OF CONTRACTCOUNT ATTRIBUTE IN TASK
--1) NEWCONTRACT TRIGGER
        -- CHECK VALUE OF CONTRACTCOUNT, IF LESS THAN 3 ALLOW INSERT OF ANOTHER WORKER.
                -- IF = 3, CANCEL INSERT, DISPLAY ERROR MESSAGE THAT IT IS FULL

--2) ENDCONTRACT TRIGGER
        -- FIRES WHEN USER ATTEMPTS TO DELETE ONE OR MORE ROWS FROM CONTRACT
            --  UPDATES VALUES OF CONTRACT COUNT FOR ANY EFFECTED TASK
            -- DECREASES VALUE OF CONTRACTCOUNT EACH TIME A WORKER IS REMOVED
--3) NOCHANGES TRIGGER
        -- FIRES WHEN USER ATTEMPTS TO UPDATE ONE OR MORE ROWS OF CONTRACT
        -- CANCELS UPDATES AND DISPLAYS ERROR MESSAGE STATING NO UPDATES ARE PERMITTED TO EXISTING ROWS
        -- STATEMENT LEVEL TRIGGER
        
--1&2 ARE ROW LEVEL TRIGGERS


--
--CREATE OR REPLACE FUNCTION CheckContractVal(TaskIDIN VarChar) RETURN l_contractVal
--AS
--l_contractVal Number;
--Begin
--l_contractval := 3;
----Select ContractCount into l_contractVal from Task Where TaskIDIn = Task.TaskID;
--DBMS_OUTPUT.PUT_LINE('Made it into checkval procedure');
--return l_contractVal;
--End;
--/


CREATE or REPLACE TRIGGER NewContract
BEFORE INSERT ON Contract FOR EACH ROW
DECLARE
conCount Number;
BEGIN

select ContractCount into conCount from Task Where taskID = :new.taskID;
IF conCount < 3 Then
    
    DBMS_OUTPUT.PUT_LINE('Countract COunt less than 3');
ELSE
    DBMS_OUTPUT.PUT_LINE('Error, contract is full');
    
End IF;
END;
/



--insert into contract values('900','1',0);
Select * from task;

--Insert into Task VALUES ('900', 'Construction',0);




