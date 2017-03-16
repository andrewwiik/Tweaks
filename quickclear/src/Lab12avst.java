import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.ArrayList;
import java.util.Scanner;

public class Lab12avst
{
   public static void main(String[] args)
   {
      MagpieLab12a maggie = new MagpieLab12a();

      System.out.println (maggie.getGreeting());
      Scanner in = new Scanner (System.in);
      String statement = in.nextLine();

      while (!statement.equals("Bye"))
      {
         System.out.println (maggie.getResponse(statement));
         statement = in.nextLine();
         
      }
   }
}


class MagpieLab12a
{
private int lastResponse;
private String name;
   public String getGreeting()
   {
      return "Hello, let's talk.";
   }

   
   public String getResponse(String statement)
   {
	  statement = statement.toLowerCase();
      String response = "";
      if (statement.indexOf("no") >= 0)
      {
         response = "why so negative?";
      }
      if (statement.indexOf("hey") >= 0 || statement.indexOf("hi") >= 0 || statement.indexOf("howdy") >= 0 || statement.indexOf("heyy") >= 0 || statement.indexOf("hola") >= 0 || statement.indexOf("yo") >= 0 )
      {
         response = "hi";
      }
      else if (statement.indexOf("name is") >= 0)
      {
    	  Pattern pattern = Pattern.compile("\\s([A-Za-z]+)");
    	  Matcher matcher = pattern.matcher(statement);
    	  if (matcher.find()) {
    			  this.name = matcher.group(2);
    	  }
    	  response = "Hello " + this.name;
      }
      
      else if (statement.indexOf("mother") >= 0
            || statement.indexOf("father") >= 0
            || statement.indexOf("sister") >= 0
            || statement.indexOf("brother") >= 0
            || statement.indexOf("family") >= 0
            || statement.indexOf("parent") >= 0)
      {
        response = getFamilyResponse();
      }
      else
      {
         response = getRandomResponse();
      }
      return response;
   }

   private String getRandomResponse()
   {
      //ArrayList<String> possibleAnswers = new ArrayList<String>(); // lets start our new deck
      String[] possibleAnswers = new String[10];
      possibleAnswers[0] = "Interesting, tell me more";
      possibleAnswers[1] = "Hmmm.";
      possibleAnswers[2] = "Do you really think so?";
      possibleAnswers[3] = "You don't say.";
      possibleAnswers[4] = "No Way!!!!";
      possibleAnswers[5] = "Really...";
      possibleAnswers[6] = "I'm sorry what did you say?";
      possibleAnswers[7] = "ERROR ERROR ERROR";
      possibleAnswers[8] = "Sorry I was making dinner, I don't understand what you are saying";
      possibleAnswers[9] = "Hey, watch your language!!!";
      
      final int NUMBER_OF_RESPONSES = possibleAnswers.length;
      double r = Math.random();
      int whichResponse = (int)(r * NUMBER_OF_RESPONSES);
      
      
      //System.out.println("Index Chosen: " + whichResponse);
      return possibleAnswers[whichResponse];
   }
   
   private String getFamilyResponse()
   {
	 ArrayList<String> possibleAnswers = new ArrayList<String>();
	 possibleAnswers.add("So how many brothers do you have");
	 possibleAnswers.add("Tell me more about your family.");
	 possibleAnswers.add("Do you have a sister?");
	 possibleAnswers.add("Do you have a brother?");
	 possibleAnswers.add("How is your mom?");
	 possibleAnswers.add("How is your dad?");
	 possibleAnswers.add("Is your aunt doing well?");
	 possibleAnswers.add("How is your Uncle?");
	 possibleAnswers.add("How is your grandma?");
	 possibleAnswers.add("How is grandpa");
	 
	 final int NUMBER_OF_RESPONSES = possibleAnswers.size();
     double r = Math.random();
     int whichResponse = (int)(r * NUMBER_OF_RESPONSES);
     return possibleAnswers.get(whichResponse);
	 
	   
   }
}
