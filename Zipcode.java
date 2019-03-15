import java.sql.*;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

// TO COMPILE javac -cp ".ojdbc6.jar;" Zipcode.java

public class Zipcode {

    Connection conn;
    String URL = "jdbc:oracle:thin:@acadoradbprd01.dpu.depaul.edu:1521:ACADPRD0";
    
    public static void main(String[] args) throws SQLException, IOException {
        Zipcode cursor = new Zipcode();
        
        //RUN CSVREADER TO POPULATE ZIPCODE TABLE
        //cursor.CSVReader();
        
        //RUN JOINTABLES TO RETRIEVE LAT/LONGS
        cursor.joinTables();   
    }
    
     public Zipcode()
    {
    try
	{
	Class.forName("oracle.jdbc.driver.OracleDriver");
        String url = "jdbc:oracle:thin:@acadoradbprd01.dpu.depaul.edu:1521:ACADPRD0";
        this.URL = url;
        conn = DriverManager.getConnection(url, "jberry12", "cdm1333796");
        conn.close();
	}
    catch (ClassNotFoundException ex) {System.err.println("Class not found " + ex.getMessage());}
    catch (SQLException ex)           {System.err.println(ex.getMessage());}
    }
     
    public void getTableInfo() throws SQLException{
        conn = DriverManager.getConnection(URL, "jberry12", "cdm1333796");
        Statement stmt = conn.createStatement();  
      
        ResultSet rs = stmt.executeQuery("select * from RESTAURANT");
        ResultSetMetaData rsmd = rs.getMetaData();
        int columnCount = rsmd.getColumnCount();
        
        while(rs.next())  
           for(int i = 1; i <= columnCount; i++){
           if (i > 1) System.out.print(",  ");
             String columnValue = rs.getString(i);
             System.out.print(columnValue + " " + rsmd.getColumnName(i));
           }
          System.out.println();
        }
    
    public void CSVReader() throws IOException, SQLException{
        String csvFile = "/Users/jberr/Desktop/HW_4/ChIzipcode.csv";
        BufferedReader br = null;
        String line = "";
        String csvSplit = ",";
        
        conn = DriverManager.getConnection(URL, "jberry12", "cdm1333796");
        String sql = "INSERT INTO ZIPCODE VALUES(?,?,?,?,?,?,?)";
        
        try{
            br = new BufferedReader(new FileReader(csvFile));
            while((line = br.readLine()) != null){
                String[] data = line.split(csvSplit);
                PreparedStatement ps = conn.prepareStatement(sql);
                Float FLat = Float.parseFloat(data[3]);
                Float FLong = Float.parseFloat(data[4]);
                int tmz = Integer.parseInt(data[5]);
                int dst = Integer.parseInt(data[6]);
                
                ps.setString(1, data[0]);
                ps.setString(2, data[1]);
                ps.setString(3, data[2]);
                ps.setFloat(4, FLat);
                ps.setFloat(5, FLong);
                ps.setInt(6, tmz);
                ps.setInt(7, dst);
                
                ps.execute();
                ps.close();
            }
            conn.close();
        }catch(Exception e){System.out.println(e);}
    }
    
    public void joinTables() throws SQLException{
        conn = DriverManager.getConnection(URL, "jberry12", "cdm1333796");
        Statement stmt = conn.createStatement();
        String query = "Select Name, Zipcode, ZL.Latitude, ZL.Longitude from RestaurantLocations RL JOIN Zipcode ZL on RL.zipcode = ZL.zip";
        ResultSet rs = stmt.executeQuery(query);
        
        while (rs.next()){
            System.out.print(rs.getString(1));
            System.out.print(", ");
            System.out.print(rs.getString(2));
            System.out.print(", ");
            System.out.print(rs.getString(3));
            System.out.print(", ");
            System.out.println(rs.getString(4));
        }
    }
}