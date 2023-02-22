void addIndent() {
  //改行
  if (mode != prevMode) {
    texts.get(texts.size()-1).setBool(false);
    if (currentLine == lines.length-1) {
      //新しい四角形を追加
      rrect.add(new RoundRect(rrX, rrY+textSpace*3, rrWidth, rrHeight));
    }
    currentLine+=1;
    currentLine = currentLine%lines.length;
    currentIndent = 0;
    indentNum = 1;

    for (int i = 0; i < texts.size(); i++) {
      float currentY = texts.get(i).y;
      float newY;
      if (currentLine == 0) {
        newY = currentY-textSpace*3;
      } else {
        newY = currentY-textSpace;
      }
      //イージングで使う値
      texts.get(i).setEasing(currentY, newY);
    }
    //四角形
    for (int i = 0; i < rrect.size(); i++) {
      float currentY = rrect.get(i).y;
      float newY;
      if (currentLine == 0) {
        newY = currentY-textSpace*3;
      } else {
        newY = currentY-textSpace;
      }
      rrect.get(i).setEasing(currentY, newY);
    }
  }

  //イージングを使って改行する
  for (int i = 0; i < texts.size(); i++) { //テキスト
    if (currentLine == 0) { //新しいシートになるとき
      texts.get(i).move(80.00);
    } else { //通常の改行
      texts.get(i).move(50.00);
    }
  }
  for (int i = 0; i < rrect.size(); i++) { //四角形
    if (currentLine == 0) { //新しいシートになるとき
      rrect.get(i).move(80.00);
    } else { //通常の改行
      rrect.get(i).move(50.00);
    }
  }

  //改行を終わらせる
  if (texts.get(0).getEY()==1) {
    currentIndent+=1;

    if (currentIndent == indentNum) {
      //新しい行を追加
      texts.add(new Text(textX, textY, currentLine));
      mode = 0;

//画面外のテキストと四角形を削除
      deleteTextAndRect();
    } 
  } //end--if (texts.get(0).getEY()==1)
} //end--addIndent()

//画面外のテキストと四角形を削除---------------------------------
void deleteTextAndRect() {
  
  if (currentLine==0 && rrect.size()>2) {
    float rrBottomY = rrect.get(0).y + rrect.get(0).rheight;
    if (rrBottomY < 0) {
      texts.subList(0, lines.length).clear(); //テキストを削除
      rrect.remove(0); //四角形を削除
    }
  }
}
