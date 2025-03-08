import de.bezier.guido.*;
final int NUM_ROWS = 10;
final int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean won = false;
private boolean lost = false;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
   buttons  = new MSButton[NUM_ROWS][NUM_COLS];
  for(int r = 0; r< NUM_ROWS; r++) {
   for(int c = 0; c < NUM_COLS; c++) {
    buttons[r][c] = new MSButton(r,c);
   }
  }
    
    
    setMines();

}
public void setMines()
{
      while (mines.size() < (NUM_ROWS * NUM_COLS) / 5) { 
        int randomRow = (int) (Math.random()*NUM_ROWS);
        int randomCol = (int) (Math.random()*NUM_COLS);
        
    if(!mines.contains(buttons[randomRow][randomCol])) {
     mines.add(buttons[randomRow][randomCol]); 
    }
      }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon() {
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked) {
                return false; 
            }
        }   }
    return true; 
}
public void displayLosingMessage()
{
  lost = true;
}
public void displayWinningMessage()
{    won = true;
}
public boolean isValid(int r, int c)
{
  if (r >= NUM_ROWS || c >= NUM_COLS) // FIX: Now correctly checks upper bounds
      return false;
  
  if (r < 0 || c < 0) // Lower bounds check remains the same
      return false;
  
  return true;
}
public int countMines(int row, int col) { 
    int boom = 0;
    for (int r = row - 1; r <= row + 1; r++) {
        for (int c = col - 1; c <= col + 1; c++) {
            if (isValid(r, c) && mines.contains(buttons[r][c])) {
                boom++;
            }
        }
    }
    return boom;
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT) {
          if(flagged == false){
          flagged = true;
         
          }
        else if(flagged == true) {
         flagged = false;
         clicked = false;
         }
        }
        else if(mines.contains(this)) {
          displayLosingMessage();
          } else if (countMines(myRow,myCol)>0) {
          setLabel(countMines(myRow,myCol));
        } else {
    for (int r = myRow - 1; r <= myRow + 1; r++) {
        for (int c = myCol - 1; c <= myCol + 1; c++) {
            if (isValid(r, c) && !buttons[r][c].clicked) {
                buttons[r][c].mousePressed();
            }
        } 
    }
}    }
    public void draw () 
    {    
      
      isWon();
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
           fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
            
            if(won == true) {
                textSize(50);
          
   text("Thanks for Playing", 200, 200);
            }
            
            if(lost == true) {

             textSize(50);
           
                text("you suck", 200, 200);
            }
        
        rect(x, y, width, height);
        fill(0);
        textSize(10);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
