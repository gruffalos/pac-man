class PacmanType {
  int _speed;
  int _x;
  int _y; 
  int _moveX, _moveY;
  int _dir;
  float _mouth, _mouthSize;
  int _counter, _size;
  int _halfGridSize;
  int _gridSize;

  PacmanType(int col, int row, int dir, int gridSize) {
    // sizes
    _gridSize = gridSize;
    _halfGridSize = gridSize / 2;
    // where is pacman?
    _x = col * gridSize;
    _y = row * gridSize;
    _dir = dir;
    // default movement
    _speed = gridSize / 10;
    _moveRight();
    // what does pacman look like?
    _mouth = 0;
    _mouthSize = PI/4;
    _size = gridSize * 9 / 10;
  }
  void draw() {
    strokeWeight(5);
    fill(255, 255, 0);
    // Circle draws clockwise..?    stroke(0);
    arc(_x + _halfGridSize, _y + _halfGridSize, _size, _size, _mouth + _mouthSize / 2, _mouth + 2*PI - _mouthSize / 2, PIE);
    //fill(0);
    //rect(_x - 5, _y - 5, 10, 10);
  }
  void update() {
    ++_counter;

    boolean isOnGrid = ((_x % _gridSize) == 0 && (_y % _gridSize) == 0);
    if (isOnGrid) {
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

    int newX = _x + _moveX * _speed;
    int newY = _y + _moveY * _speed;
    int halfSize = _size / 2;

    println(_x, _y, "new", newX, newY, "dir", _dir);

    if (!isOnGrid) {
      _x = newX;
      _y = newY;
    } else if (maze.isSpace(newX - halfSize, newY - halfSize) &&
      maze.isSpace(newX + halfSize, newY + halfSize) &&
      maze.isSpace(newX + halfSize, newY - halfSize) &&
      maze.isSpace(newX - halfSize, newY + halfSize)) {
      _x = newX;
      _y = newY;
    } else {
      // cannot move, or we'd run into a wall
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
  final int _size = 50;
  final int BIG_FOOD = 3;
  final int FOOD = 2;
  final int WALL = 1;
  final int VOID = 0;
  PacmanType _pacman;
  int _data[][];

  MazeType() {
    String repr[] = {
     //12345678911131517
      "XXXXXXXXXXXXXXXXX",// 1
      "XfffffffXfffffffX",// 2
      "XfXfXfXfffXfXfXfX",// 3
      "XfXfffXXfXXfffXfX",// 4
      "XfffXfXfffXfXfffX",// 5
      "XXXfXfffXfffXfXXX",// 6
      "XfffXfXfffXfXfffX",// 7
      "XfXfffXXfXXfffXfX",// 8
      "XfXfXfXf^fXfXfXfX",// 9
      "XfffffffXfffffffX",// 10
      "XXXXXXXXXXXXXXXXX",// 11
    };

    _data = new int[repr.length][];
    for (int y = 0; y < repr.length; ++y) {
      String row = repr[y];
      _data[y] = new int[row.length()];
      for (int x = 0; x < row.length(); ++x) {
        switch (row.charAt(x)) {
        case 'X':
          _data[y][x] = WALL;
          break;
        case 'f':
          _data[y][x] = FOOD;
          break;
        case 'F':
          _data[y][x] = BIG_FOOD;
          break;
        case '^':
          _pacman = new PacmanType(x, y, 0, _size);
          _pacman.moveUp();
        case ' ':
        default:
          _data[y][x] = VOID;
        }
      }
    }
  }
  boolean isSpace(int x, int y) {
    return _getObject(x, y) != WALL;
  }
  boolean isFood(int x, int y) {
    return _getObject(x, y) == FOOD;
  }
  int _getObject(int x, int y) {
    int row = (y + _size / 2) / _size;
    int col = (x + _size / 2) / _size;
    //println(x, y, row, col);
    if ((row < 0 || row >= _data.length) ||
      (col < 0 || col >= _data[row].length)) {
      return WALL;
    }
    return _data[row][col];
  }
  void _drawMaze() {
    for (int y = 0; y < _data.length; ++y) {
      for (int x = 0; x < _data[y].length; ++x) {
        switch (_data[y][x]) {
        case WALL:
          noStroke();
          fill(0, 0, 254);
          rect(x * _size, y * _size, _size, _size);
          break;
        case FOOD:
          fill(#E8F743);
          stroke(#E8F743);
          circle(x * _size + _size / 2, y * _size + _size / 2, _size / 10);
          break;
        case BIG_FOOD:
          fill(#E8F743);
          stroke(#E8F743);
          circle(x * _size + _size / 2, y * _size + _size / 2, _size / 5);
          break;
        }
      }
    }
  }    
  void draw() {
    _drawMaze();
    _pacman.draw();
  }
}  


PacmanType pacman;
MazeType maze;
void setup() {
  fullScreen();
  //size(800, 800);
  maze = new MazeType();
  pacman = maze._pacman; // XXX
}

void draw() {
  background(255);
  pacman.update();
  maze.draw();
}

void keyPressed() {
  switch (key == CODED ? keyCode : key) {
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
  case 'q':
    exit();
  }
}
