import geomerative.*;
import java.util.Calendar;

RShape[] grp;
RShape[] emo;
int currentLine = 0;
int time = 0;
int interval = 1000; //１文書く間隔（数値が大きいほど遅くなる）
int textSpace = 65; //行間
int textWidth = 35; //文字の大きさ
int bodyFrame = 0;
int eyeFrame = 0;
int wink, indentNum, currentIndent;
int mode = 0; //0:テキストを書く 1:改行 2:にらむ 3:文字を消す
int prevMode; //１フレーム前のmodeの値
int[] intervals;
float div, textX, textY, imageX, imageY, rrX, rrY, rrHeight, textHeight;
float padding = 50;
float rrWidth = 680; //四角形の幅
String fontName = "KTEGAKI.ttf";
String[] lines;
PFont windowMessage;
PImage[] images = new PImage[3];
PImage[] imagesB = new PImage[3];
PImage[] eyes = new PImage[3];
PImage[] eyesB = new PImage[3];
boolean bEye = false;
boolean prevbEye; //１フレーム前のbEyeの値
boolean bLight = true;
ArrayList<Text> texts = new ArrayList<Text>();
ArrayList<RoundRect> rrect = new ArrayList<RoundRect>();
FloatList textCurrentY = new FloatList();

void setup() {
  size(1080, 608);
  frameRate(60);
  smooth();

  //文章をロード
  RG.init(this);
  loadText();
  grp = new RShape[lines.length];

  for (int i = 0; i < lines.length; i++) {
    grp[i] = RG.getText(lines[i], fontName, textWidth, LEFT);
  }

  //画像をロード
  //ナツキ
  for (int i = 0; i < images.length; i++) {
    String imageName = "ani-" + nf(i, 1) + ".png";
    images[i] = loadImage(imageName);
  }
  //ナツキ（暗）
  for (int i = 0; i < imagesB.length; i++) {
    String imageName = "ani-" + nf(i, 1) + "b.png";
    imagesB[i] = loadImage(imageName);
  }
  //目
  for (int i = 0; i < eyes.length; i++) {
    String imageName = "eye-" + nf(i, 1) + ".png";
    eyes[i] = loadImage(imageName);
  }
  //目（暗）
  for (int i = 0; i < eyesB.length; i++) {
    String imageName = "eye-" + nf(i, 1) + "b.png";
    eyesB[i] = loadImage(imageName);
  }

  //画像の位置
  imageX = width-images[0].width-20;
  imageY = height-images[0].height-10;
  //テキストのy位置
  textX = 80;
  textY = height-90;
  //最初のテキストを追加
  texts.add(new Text(textX, textY, 0));

  //１文書く間隔（どの文の長さでも描画スピードを一定にする）
  intervals = new int[lines.length];
  float lw = rrWidth-padding*2;
  div = interval/lw;
  for (int i = 0; i < intervals.length; i++) {
    //文の幅を取得
    float lineWidth = grp[i].getBottomRight().x - grp[i].getBottomLeft().x;
    intervals[i] = int(div*lineWidth);
  }

  //四角形を追加
  rrX = textX-padding;
  rrY = textY-textWidth-padding;
  rrHeight = textSpace*(lines.length)+padding*2-textWidth/2;
  rrect.add(new RoundRect(rrX, rrY, rrWidth, rrHeight));
}

void draw() {
  background(#646182);

  lightSwitch();

  //ナツキ
  if (bLight) {
    image(images[bodyFrame], imageX, imageY);
  } else {
    image(imagesB[bodyFrame], imageX, imageY);
  }
  int frame = frameCount % 8; //画像が切り替わるスピードを調整
  if (mode == 0) { //テキストの描画をしてるときだけ動く
    if (frame == 1) {
      bodyFrame = int(random(3));
    }
  }
  //目
  if (bLight) {
    image(eyes[eyeFrame], imageX, imageY);
  } else {
    image(eyesB[eyeFrame], imageX, imageY);
  }
  if (mode == 0 || mode == 1) { //テキストを書く、改行
    wink(0, 2); //0~2番目の目の画像を使用
  }


  //四角形の描画
  for (int i = 0; i < rrect.size(); i++) {
    rrect.get(i).display();
  }

  //テキスト
  if (mode == 0) {
    if (grp[currentLine].countChildren() == 0) mode = 1; //文字が空白のときは改行
  }

  for (int i = 0; i < texts.size(); i++) {
    texts.get(i).display(); //テキスト表示
  }

  if (mode == 0) { //文章を書いてるとき
    time++;
  }

  if (time%intervals[currentLine] == 0) { //１文書き終わったとき
    mode = 1;
    time = 0;
  }

  if (mode == 1) { //改行
    addIndent();
  }

  prevMode = mode;
  prevbEye = bEye;
}

void keyPressed() {
  if (key == 's' || key == 'S')saveFrame(timestamp()+"_####.png");
}

void lightSwitch() {
  if (frameCount%8==0) {
    int space = int(random(40));
    if (space < 1) {
      bLight = false;
    } else {
      bLight = true;
    }
  }
}

void wink(int first, int end) { //目のまばたき
  int space = int(random(93, 150)); //まばたきするタイミング（ランダム）
  int frame2 = frameCount % space;
  if (frame2 == space-1) {
    bEye = true; //まばたきを有効にする
  }
  if (bEye) {
    if (bEye != prevbEye) {
      wink = 0; //まばたきに使う数値
    }
    //まばたきのスピード
    if (wink%4 == 3) {
      eyeFrame += 1;
    }
  }
  //まばたき終了
  if (eyeFrame == end+1) {
    bEye = false;
    eyeFrame = first;
  }
  wink++;
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
