# slideparty

[![codecov](https://codecov.io/gh/definev/slideparty/branch/main/graph/badge.svg?token=J26MGZC9XN)](https://codecov.io/gh/definev/slideparty)
## Inspiration
I want to make a puzzle game that runs on **all platforms**:  Android, iOS, Linux, Windows and MacOS. You can play with your friends regardless of what operating system you are using, you just need to have a room number to be able to play online and compete with your friends or you can directly compete with your friends. locally by various types of controls for different types of screens.

## What it does
Just a casual and fun puzzle game!

## How we built it
The game has two part:
- Client: I use flutter to make truly one codebase for across platform.
- Server: I use shelf to make a web server in dart.

### Client
Slideparty has three game-mode
- Single mode: Play and try to solve as fast as you can a 3x3, 4x4 or 5x5 puzzle board.
        - Features:
    1. Auto solving
    2. Multiple ways to control game base on current devices
- Multiple mode: Play with friends in local, you can play upto 4 players.
       - Features:
    1. Responsive layout
    2. Multiple ways to control game base on current devices
    3. Some sort of skills to prevent or annoying your friends for fun
- Online mode: Enter a room code and you can play like multiple mode but on different devices.
      - Features:
    1. Real-time communication
    2. All features in multiple mode

### Server
Slideparty server use websocket for handle real-time interaction between players.

Use `shelf` and `shelf_router` to making a web server is pretty straight-forward.

I seperate how client talking to server with mono-package [slideparty_socket](https://github.com/definev/slideparty_socket) base on websocket, basically when client send an event and server handle that event, processing how the playboard changed and send back to client a json decoded. 
 

## Challenges we ran into

Auto-solver is pretty hard, first i'm trying to use A* algorithms to find the best solutions. It works well with 3x3 puzzle ... but with 4x4 the time complexity is so huge and immediately block UI thread so with this approach, impossible to solve 4x4 and 5x5 while keeping the app run smooth.

![bob](https://user-images.githubusercontent.com/62325868/152034506-4978f730-f636-4fb1-aa73-44a79ca4e7b0.svg)


After that I trying to find a pattern of the game then i found that if we solve the first row and first column of a N x N playboard and you remain exact (N - 1) x (N - 1) playboard and you can keep solving until N = 1 you solve the puzzle! This solution isn't return the shortest step to solve but it's run pretty fast and it's can solve any N x N board so i'm accept that is not the best solution but it is the fast enough to run smooth solution.

## What we learned

Have fun with flutter
Discover how to use dart for backend

## Testing

I tried to test all the essential parts of the game. It's not 100% coverage but it's still more reliable than no testing. To test this game, run the command:
```
flutter test
```
