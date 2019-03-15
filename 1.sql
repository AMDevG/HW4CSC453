Drop Table RestaurantLocations;
Create TABLE RestaurantLocations(rID int, name varchar2(100), street_address varchar2(100), city varchar2(100), state varchar(3), zipcode varchar2(6), cuisine varchar2(100));

DECLARE
    subName Restaurant.Address%TYPE;
    Addr Restaurant.Address%TYPE;
    cuisine Restaurant.cuisine%TYPE;
    subRID restaurant.rid%TYPE;
    SubAddr Restaurant.Address%TYPE;
    StreetAddr Restaurant.Address%TYPE;
    ZipAddr varchar(6);
    
    CURSOR addrCursor IS 
    SELECT NAME, ADDRESS, RID, CUISINE
        FROM RESTAURANT;
BEGIN
OPEN addrCursor;
LOOP
    FETCH addrCursor into subName, Addr, subrid, Cuisine;
    IF addrCursor%FOUND THEN
         ZipAddr := SUBSTR(Addr, -5);
         SubAddr := REGEXP_SUBSTR(Addr,'[^,]+',1,1);
         StreetAddr := REPLACE(SubAddr,' Chicago');
         DBMS_OUTPUT.PUT_LINE( subrid || ' , ' || subName || ' , ' || streetAddr || ' , ' ||ZipAddr );
         INSERT INTO RestaurantLocations VALUES(subrid, subName, streetAddr, 'Chicago', 'IL', ZipAddr, cuisine);
    END IF;
    EXIT WHEN addrCursor%NOTFOUND;
END LOOP;
CLOSE addrCursor;
END;



