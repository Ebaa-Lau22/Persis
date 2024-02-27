import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:Persis/Persis/structure/player.dart';
import 'package:Persis/Persis/style/colors.dart';

class Board {

  static List<List<int>> board = [
    [-1, -1, -1, -1, -1, -1, -1, -1, 43, 42, 41, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 44, 107, 40, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 45, 106, 39, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, 2000, -1, -1, 46, 105, 38, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, 2001, -1, -1, -1, 47, 104, 37, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, 2002, -1, 2003, -1, -1, 48, 103, 36, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 49, 102, 35, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 50, 101, 34, -1, -1, -1, -1, -1, -1, -1, -1],
    [58, 57, 56, 55, 54, 53, 52, 51, -2, -2, -2, 33, 32, 31, 30, 29, 28, 27, 26],
    [59, -2, -2, -2, -2, -2, -2, -2, -2, 84, -2, -2, -2, -2, -2, -2, -2, -2, 25],
    [60, 61, 62, 63, 64, 65, 66, 67, -2, -2, -2, 17, 18, 19, 20, 21, 22, 23, 24],
    [-1, -1, -1, -1, -1, -1, -1, -1, 68, 1, 16, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 69, 2, 15, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 70, 3, 14, -1, -1, 1003, -1, 1000, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 71, 4, 13, -1, -1, -1, 1001, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 72, 5, 12, -1, -1, 1002, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 73, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 74, 7, 10, -1, -1, -1, -1, -1, -1, -1, -1],
    [-1, -1, -1, -1, -1, -1, -1, -1, 75, 8, 9, -1, -1, -1, -1, -1, -1, -1, -1],
  ];
  static HashSet<int> safeTilesPlayer1 = HashSet();
  static HashSet<int> safeTilesPlayer2 = HashSet();

  static Widget getTileImage(Player player, Player computer, int index, double tileSide) {
    if(index == -2) {
      return Image(
        image: const AssetImage('assets/images/royal_tile.png'),
        height: tileSide,
        width: tileSide,
        fit: BoxFit.cover,
      );
    }
    if(index == -1) {
      return SizedBox(
        height: tileSide,
        width: tileSide,
      );
    }
    if(index>999 && index<1004){
      int i = index - 1000;
      if(player.rocks[i] != 0){
        return Image(
          image: const AssetImage('assets/images/empty_tile.png'),
          height: tileSide,
          width: tileSide,
          fit: BoxFit.cover,
        );
      } else {
        return Image(
          image: const AssetImage('assets/images/p1c0.png'),
          height: tileSide,
          width: tileSide,
          fit: BoxFit.cover,
        );
      }
    }
    if(index>1999 && index<2004){
      int i = index - 2000;
      if(computer.rocks[i] != 100){
        return Image(
          image: const AssetImage('assets/images/empty_tile.png'),
          height: tileSide,
          width: tileSide,
          fit: BoxFit.cover,
        );
      } else {
        return Image(
          image: const AssetImage('assets/images/p0c1.png'),
          height: tileSide,
          width: tileSide,
          fit: BoxFit.cover,
        );
      }
    }
    int playerCnt = rocksOnTileCounter(index, player);
    int computerCnt = rocksOnTileCounter(index, computer);
    bool safe = false;
    for(int i in safeTilesPlayer1){
      if(i == index) safe = true;
    }
    if(playerCnt == 0 && computerCnt == 0) {
      if(safe){
        return Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/empty_tile.png'),
                  height: 20,
                  width: 20,
                  fit: BoxFit.cover,
                ),
                Transform.rotate(
                  angle: 45 *  pi / 180,
                  child: Container(
                    color: gold.withAlpha(200),
                    width: 1,
                    height: 18 ,
                  ),
                ),
              ],
            ),
            Transform.rotate(
              angle: -45 *  pi / 180,
              child: Container(
                color: gold.withAlpha(200),
                width: 1,
                height: 18 ,
              ),
            ),
          ],
        );
      }
      return Image(
        image: const AssetImage('assets/images/empty_tile.png'),
        height: tileSide,
        width: tileSide,
        fit: BoxFit.cover,
      );
    } else {
      if(safe){
        return Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/p${playerCnt}c$computerCnt.png'),
                  height: 20,
                  width: 20,
                  fit: BoxFit.cover,
                ),
                Transform.rotate(
                  angle: 45 *  pi / 180,
                  child: Container(
                    color: gold.withAlpha(200),
                    width: 1,
                    height: 18 ,
                  ),
                ),
              ],
            ),
            Transform.rotate(
              angle: -45 *  pi / 180,
              child: Container(
                color: gold.withAlpha(200),
                width: 1,
                height: 18 ,
              ),
            ),
          ],
        );
      }
      return Image(
        image: AssetImage('assets/images/p${playerCnt}c$computerCnt.png'),
        height: tileSide,
        width: tileSide,
        fit: BoxFit.cover,
      );
    }
  }

  static int rocksOnTileCounter(int index, Player player) {
    int cnt = 0;
    if ((index > 0 && index <= 8) || (index > 100 && index <= 108)) {
      if (index == 1) {
        cnt += rocksOnTileCounter(83, player);
      } else if (index == 2) {
        cnt += rocksOnTileCounter(82, player);
      } else if (index == 3) {
        cnt += rocksOnTileCounter(81, player);
      } else if (index == 4) {
        cnt += rocksOnTileCounter(80, player);
      } else if (index == 5) {
        cnt += rocksOnTileCounter(79, player);
      } else if (index == 6) {
        cnt += rocksOnTileCounter(78, player);
      } else if (index == 7) {
        cnt += rocksOnTileCounter(77, player);
      } else if (index == 101) {
        cnt += rocksOnTileCounter(183, player);
      } else if (index == 102) {
        cnt += rocksOnTileCounter(182, player);
      } else if (index == 103) {
        cnt += rocksOnTileCounter(181, player);
      } else if (index == 104) {
        cnt += rocksOnTileCounter(180, player);
      } else if (index == 105) {
        cnt += rocksOnTileCounter(179, player);
      } else if (index == 106) {
        cnt += rocksOnTileCounter(178, player);
      } else if (index == 107) {
        cnt += rocksOnTileCounter(177, player);
      }
    }

    if (player.isPlayer2) {
      if (index < 108 && index > 100 || index>176 && index<184) {
        for (int pos in player.rocks) {
          if (index == pos) cnt++;
        }
      }
      else if (index >= 42 && index <= 75) {
        for (int pos in player.rocks) {
          if (index + 66 == pos || index == 42 && pos == 176) cnt++;
        }
      }
      else if (index >= 8 && index <= 41) {
        for (int pos in player.rocks) {
          if (index + 134 == pos) cnt++;
        }
      }
    }
    else {
      for (int pos in player.rocks) {
        if (index == pos || index == 8 && pos == 76) cnt++;
      }
    }
    return cnt;
  }
  static int getOtherPlayerIndexForTile(int index, bool isOtherComputer){
    if(isOtherComputer){
      if(index == 76) index = 8;
      if(index <= 7 && index > 0 || index<84 && index >= 77) return -1;
      if (index >= 42 && index <= 75){
        return index + 66;
      }
      if(index >= 8 && index <= 41){
        return index + 134;
      }
    }
    if(index == 176) index = 108;
    if(index <= 107 && index > 100 || index<184 && index >= 177) return -1;
    if (index >= 108 && index <= 141){
      return index - 66;
    }
    else{
      return index - 134;
    }
  }
  static int getCurrentPlayerIndexForTile(int index, bool isCurrentComputer){
    if(isCurrentComputer){
      if(index>=2000 && index<=2003) return 100;
      if(index>=101 && index<=107) return index;
      if(index>=42 && index<=75) return index + 66;
      if(index>=8 && index <= 41) return index + 134;
      if(index == 84) return 184;
      return -1;
    }
    else{
      if(index>=1000 && index<=1003) return 0;
      if(index>=1 && index<=75) return index;
      if(index == 84) return index;
      return -1;
    }
  }
  static int getSecondIndexForTile(int index){
    if(index == 1) return 83;
    if(index == 2) return 82;
    if(index == 3) return 81;
    if(index == 4) return 80;
    if(index == 5) return 79;
    if(index == 6) return 78;
    if(index == 7) return 77;
    if(index == 8) return 76;
    if(index == 101) return 183;
    if(index == 102) return 182;
    if(index == 103) return 181;
    if(index == 104) return 180;
    if(index == 105) return 179;
    if(index == 106) return 178;
    if(index == 107) return 177;
    if(index == 108) return 176;
    return -1;
  }

  static HashSet<int> oneMoveDanger = HashSet();
  static HashSet<int> twoMoveDanger = HashSet();

  static initSets (){
    safeTilesPlayer1.addAll([11, 22, 28, 39, 45, 56, 62, 73]);
    safeTilesPlayer2.addAll([111, 122, 128, 139, 145, 156, 162, 173]);
    oneMoveDanger.addAll([1, 2, 3, 4, 6, 10, 11, 12, 24, 25]);
    twoMoveDanger.addAll([5, 7, 13, 14, 15, 16, 17, 20, 21, 22, 23, 26, 27, 28, 29, 30, 31, 34, 35, 37, 48, 49, 50]);
  }
}