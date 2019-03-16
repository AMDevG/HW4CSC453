CREATE or REPLACE TRIGGER NewContract
BEFORE INSERT ON Contract FOR EACH ROW
DECLARE
conCount Number;
BEGIN

Select ContractCount into conCount from Task Where taskID = :new.taskID;
DBMS_OUTPUT.PUT_LINE('TASKid BEING UPDATED in newcontract' || :new.taskID);

IF conCount < 3 Then
    conCount := conCount +1;
    Update Task SET contractCount = conCount Where taskID = :new.taskID;
    DBMS_OUTPUT.PUT_LINE('Countract COunt= ' || concount);
ELSE
    raise_application_error (-20101,'Contract is full');
End IF;
END;
/

-- BUG IS DELETING CONTRACT COUNT 3 TIMES OVER UNTIL ZERO DUE TO MULTIPLE TASK 
CREATE or REPLACE TRIGGER EndContract
BEFORE DELETE ON Contract FOR EACH ROW
DECLARE
conCount Number;
BEGIN
Select ContractCount into conCount from Task Where TaskID = :OLD.taskID;
DBMS_OUTPUT.PUT_LINE('Deleting contract from task ' || :OLD.taskID || 'currentCount ' || conCOunt);

IF conCount > 0 Then
    conCount := conCount - 1;
    DBMS_OUTPUT.PUT_LINE('Contract Count for ' ||:OLD.taskID|| ' is ' || conCOunt);
    Update Task SET contractCount = conCount Where taskID = :OLD.taskID;
ELSE
    Update Task SET contractCount = conCount Where taskID = :OLD.taskID;
    raise_application_error (-20101,'Contract is empty');
End IF;
END;
/

CREATE or REPLACE TRIGGER NoChanges
Before Update ON Contract
DECLARE
BEGIN
     DBMS_OUTPUT.PUT_LINE('Firing No Changes Blocking Update');
    raise_application_error (-20101,'No Updates are Permitted');
END;
/
--DELETE FROM CONTRACT WHERE TASKID = '333';
--UPDATE CONTRACT SET WorkerID = '12' WHERE TASKID = '333';
--Select * from task;
--Select * from contract;
--Insert into Task VALUES ('901', 'Gardening',0);
--Insert into Contract Values ('896', '04', 0);




