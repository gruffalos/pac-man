class PacmanType {
  final int _speed = 10;
  int _x = 900;
  int _y = 600; 
  int _moveX, _moveY;
  int _dir;
  float _mouth, _mouthSize;
  int _counter, _size;
  int _halfGridSize;
  int _gridSize;

  PacmanType(int x, int y) {
    _gridSize = maze.getSize();
    _halfGridSize = _gridSize / 2;
    _x = x - (x % _gridSize);
    _y = y - (y % _gridSize);
    _mouth = 0;
    _mouthSize = PI/4;
    _size = _gridSize * 9 / 10;
    _moveRight();
  }
  void draw() {
    strokeWeight(5);
    fill(255, 255, 0);
    // Circle draws clockwise..?    stroke(0);
    arc(_x + 50, _y + 50, _size, _size, _mouth + _mouthSize / 2, _mouth + 2*PI - _mouthSize / 2, PIE);
    //fill(0);
    //rect(_x - 5, _y - 5, 10, 10);
  }
  void update() {
    ++_counter;
    int newX = _x + _moveX * _speed;
    int newY = _y + _moveY * _speed;
    int halfSize = _size / 2;


    println(_x, _y, "new", newX, newY, "dir", _dir);
    //noStroke();
    if (maze.isSpace(newX - halfSize, newY - halfSize) &&
      maze.isSpace(newX + halfSize, newY + halfSize) &&
      maze.isSpace(newX + halfSize, newY - halfSize) &&
      maze.isSpace(newX - halfSize, newY + halfSize)) {
      _x = newX;
      _y = newY;
    }

    if ((_x % _gridSize) == 0 && (_y % _gridSize) == 0) {
      switch (_dir) {
      case 0:
        _moveRight();
        break;
      case 1:
        _moveUp();
        break;
      case 2:
        _moveLeft();
        break;
      case 3:
        _moveDown();
        break;
      }
    }

    if ((_counter % 10) == 0) {
      if (_mouthSize >= PI/4) {
        _mouthSize = 0;
      } else {
        _mouthSize = PI/4;
      }
    }
  }
  void moveLeft() {
    _dir = 2;
  }
  void _moveLeft() {
    _moveX = -1;
    _moveY = 0;
    _mouth = PI;
  }
  void moveRight() {
    _dir = 0;
  }
  void _moveRight() {
    _moveX = 1;
    _moveY = 0;
    _mouth = 0;
  }
  void moveUp() {
    _dir = 1;
  }
  void _moveUp() {
    _moveX = 0;
    _moveY = -1;
    _mouth = -PI/2;
  }
  void moveDown() {
    _dir = 3;
  }
  void _moveDown() {
    _moveX = 0;
    _moveY = 1;
    _mouth = PI/2;
  }
}

class MazeType {
  final int _size = 100;
  boolean _data[][];

  MazeType() {
    /*
    String repr[] = {
      "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", 
      "X        X                       X", 
      "X XX XXX X XXX XX                X", 
      "X XX XXX X XXX XX                X", 
      "X                                X", 
      "X XXX X  X  X XXX                X", 
      //"X                                X",
      "X     X  X  X                    X", 
      "X     XX X XX                    X", 
      //"X                                 X",
      //"X                                 X",
      //"X                                 X",
      "X     X     X                    X", 
      "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", 
    };
    */
    String repr[] = {
      "XXXXXXXX", 
      "X      X", 
      "X XX   X", 
      "X X    X", 
      "X      X",      
      "X X    X", 
      "XXXXXXXX", 
    };

    _data = new boolean[repr.length][];
    for (int y = 0; y < repr.length; ++y) {
      String row = repr[y];
      _data[y] = new boolean[row.length()];
      for (int x = 0; x < row.length(); ++x) {
        _data[y][x] = (row.charAt(x) == 'X');
      }
    }
  }
  int getSize() {
    return _size;
  }
  boolean isSpace(int x, int y) {
    int row = (y + 50) / _size;
    int col = (x + 50) / _size;
    //println(x, y, row, col);
    if ((row < 0 || row >= _data.length) ||
      (col < 0 || col >= _data[row].length)) {
      return false;
    }
    return !_data[row][col];
  }
  void draw() {
    for (int y = 0; y < _data.length; ++y) {
      for (int x = 0; x < _data[y].length; ++x) {
        if (_data[y][x]) {
          noStroke();
          fill(0, 0, 254);
          rect(x * _size, y * _size, _size, _size);
        }
      }
    }
  }
}  

class EtenType {
  int _etenX;
  int _etenY;
  EtenType(int x, int y) {
    _etenX = x;
    _etenY = y;
  }
  void draw() {
    //point()
  }
}
PacmanType pacman;
MazeType maze;
EtenType eten;
void setup() {
  //fullScreen();
  size(800, 800);
  maze = new MazeType();
  pacman = new PacmanType(width / 2, height / 2);
}

void draw() {
  background(255);
  pacman.update();
  pacman.draw();
  maze.draw();
  //eten.draw();
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      pacman.moveUp();
      println("up");
      break;
    case DOWN:
      pacman.moveDown();
      println("down");
      break;
    case LEFT:
      pacman.moveLeft();
      println("left");
      break;
    case RIGHT:
      pacman.moveRight();
      println("right");
      break;
    }
  }
}
