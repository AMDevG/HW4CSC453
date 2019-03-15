

DROP TABLE Top5restaurants;
Create table Top5Restaurants(rID int); 

CREATE OR REPLACE PROCEDURE AddReview(RestaurantNameIN IN STRING, UserNameIN IN STRING, RatingIn IN NUMBER, RatingDateIN IN DATE) 
AS
RestID Restaurant.RID%TYPE;
UseID Reviewer.VID%TYPE;
Rate Rating.Stars%TYPE;
RateDate Rating.RatingDate%TYPE;

BEGIN
DBMS_OUTPUT.PUT_LINE('Inserting Review');

 SELECT RID into RestID FROM RESTAURANT WHERE Name = RestaurantNameIN;
 SELECT VID into UseID FROM Reviewer Where Name = UserNameIN;
 INSERT INTO RATING VALUES(RestID, UseID, RatingIN, RatingDateIN);
 END;
 /
 
CREATE or REPLACE TRIGGER Rating_Calc
AFTER INSERT ON RATING 

DECLARE
RateNum Rating.Stars%TYPE;
RestIDs Rating.RID%TYPE;
countNum Number;

Cursor Rest_Cur IS
Select RID into RestIDS from (Select Distinct RID, STARS from Rating order by STARS desc) where rownum <=5;

rest_t Rest_cur%ROWTYPE;
TYPE rest_ntt IS TABLE OF rest_t%TYPE;
l_rest rest_ntt;

BEGIN
DBMS_OUTPUT.PUT_LINE('Firing Trigger');

OPEN Rest_Cur;
Fetch Rest_Cur BULK COLLECT INTO l_rest;
CLOSE Rest_cur;
DELETE FROM top5restaurants WHERE RID != NULL;

Select COUNT(*) Into CountNum From top5restaurants;

IF (countNum < 1) THEN
    For indx IN 1..5 LOOP
        INSERT INTO top5Restaurants VALUES(l_rest(indx).RID);
    END LOOP;

ELSE 
    For indx IN 1..5 LOOP
        UPDATE top5restaurants SET RID = l_rest(indx).RID where RID != NULL;
    END LOOP;
END IF;
END; 
/

EXEC AddReview('Jade Court', 'Sarah M.', 4,'17-AUG-2017');
EXEC AddReview('Shanghai Terrace', 'Cameron J.', 5,'17-AUG-2017');
EXEC AddReview('Rangoli', 'Vivek T.', 3,'17-SEP-2017');
EXEC AddReview('Cumin', 'Cameron J.', 2,'17-SEP-2017');
