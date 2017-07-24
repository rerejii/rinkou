/*
   --画像処理演習課題--
   所属:情報学群 2回生
   学籍番号:1190361
   氏名:早川 晋矢
*/
import java.io.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.awt.Color;
//黒=0,白=1
class Thinning {
	/* 色の値の取得準備 */
	static ImageUtility iu = new ImageUtility();
	static int brack = iu.rgb(0,0,0);//黒
	static int white = iu.rgb(255,255,255);//白
  public static void main(String args[]){
    try{
      /* 入力画像の読み込み */
			BufferedImage readImage = ImageIO.read(new File(args[0])); //第一引数をファイル名とする
			int w = readImage.getWidth(); //横幅
			int h = readImage.getHeight(); //縦幅
      /* 出力画像の準備 */
			BufferedImage writeImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
      gray(readImage, writeImage, w, h);
      two_color(writeImage, writeImage, w, h);
      //for(int i = 0; i < 11; i++){
      thinning(writeImage, w, h);
      //}
      /* output.pngへの書き込み */
      ImageIO.write(writeImage, "png", new File("output.png"));
    }catch (IOException e){
			/* 例外処理 */
			throw new RuntimeException(e.toString());
		}
		System.out.println("画像処理が完了しました");
	}
//以下メソッドの定義-----------------------------------
  /* グレースケールメソッド */
  public static void gray(BufferedImage readImage, BufferedImage writeImage, int w, int h){
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        int color = toGray(readImage.getRGB(x, y)); // 入力画像の画素値を取得
        writeImage.setRGB(x, y, color); //出力画像に画素値をセット
      }
    }
  }

  //グレースケール変換（NTSC係数による加重平均法）
  //http://javatec.blog105.fc2.com/blog-entry-84.htmlより
  protected static int toGray(int col){
   Color c = new Color(col);
   double d = (double)(2*c.getRed()+4*c.getGreen()+c.getBlue())/7d;
   int a = c.getAlpha();
   c = new Color((int)d, (int)d, (int)d, a);
   return c.getRGB();
  }

  /* 2極化メソッド */
  public static void two_color(BufferedImage readImage, BufferedImage writeImage, int w, int h){
   for (int y = 0; y < h; y++) {
     for (int x = 0; x < w; x++) {
       int color = readImage.getRGB(x, y); // 入力画像の画素値を取得
       int c = (iu.r(color) + iu.g(color) + iu.b(color)) / 3;//画素数ん平均値を求める
       if( c < 160){
       //if( c < 155){
         writeImage.setRGB(x, y, brack); //出力画像に画素値をセット
       }else{
         writeImage.setRGB(x, y, white); //出力画像に画素値をセット
       }
     }
   }
  }

   /* 細線化メソッド */
  public static void thinning(BufferedImage image, int w, int h){
  /*[P9][P2][P3]
   [P8][P1][P4]
   [P7][P6][P5]*/
    /* 色の値の取得準備 */
    ImageUtility iu = new ImageUtility();
    int[][] thinning_box = new int[w][h];//[x][y]
    int[] check_box = new int[10];//[null,p1,p2,p3,p4,p5,p6,p7,p8,p9]
    boolean change_swith = false;
    int count = 0;
    //step1-----------------------
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
       int color = image.getRGB(x, y); // 入力画像の画素値を取得
       if(color == brack){
         thinning_box[x][y] = 0;
         continue;
       }
       int x1 = f1(image, x, y, w, h);
       //if(!(x1 >= 1 && x1 <= 2)){
       if(!(x1 == 1)){
         thinning_box[x][y] = 0;
         continue;
       }
       int x2 = f2(image, x, y, w, h);
       if(!(x2 >= 2 && x2 <= 6)){
         thinning_box[x][y] = 0;
         continue;
       }
       check_color(image, check_box, x, y, w, h);
       if((check_box[2] == 0 || check_box[4] == 0 || check_box[6] == 0) &&
       (check_box[4] == 0 || check_box[6] == 0 || check_box[8] == 0)){
         thinning_box[x][y] = 1;//条件を満たすピクセルを保存
       }else{
         thinning_box[x][y] = 0;//条件を満たさないピクセルを破棄
       }
      }
    }
    //step1後編集
    for (int y = 0; y < h; y++) {
     for (int x = 0; x < w; x++) {
       if(thinning_box[x][y] == 1){
         change_swith = true;
         count++;
         image.setRGB(x, y, brack); //出力画像に画素値をセット
       }
     }
    }
    //step2----------------------------
    for (int y = 0; y < h; y++) {
     for (int x = 0; x < w; x++) {
       int color = image.getRGB(x, y); // 入力画像の画素値を取得
       if(color == brack){
         thinning_box[x][y] = 0;
         continue;
       }
       int x1 = f1(image, x, y, w, h);
       //if(!(x1 >= 1 && x1 <= 2)){
       if(!(x1 == 1)){
         thinning_box[x][y] = 0;
         continue;
       }
       int x2 = f2(image, x, y, w, h);
       if(!(x2 >= 2 && x2 <= 6)){
         thinning_box[x][y] = 0;
         continue;
       }
       check_color(image, check_box, x, y, w, h);
       if((check_box[2] == 0 || check_box[4] == 0 || check_box[8] == 0) &&
       (check_box[2] == 0 || check_box[6] == 0 || check_box[8] == 0)){
         thinning_box[x][y] = 1;//条件を満たすピクセルを保存
       }else{
         thinning_box[x][y] = 0;//条件を満たさないピクセルを破棄
       }
     }
   }
   //step2後編集
   for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
       if(thinning_box[x][y] == 1){
         change_swith = true;
         count++;
         image.setRGB(x, y, brack); //出力画像に画素値をセット
       }
      }
    }
    if(change_swith == true){
      System.out.print(count + "/");
      thinning(image, w, h);
    }
  }

  //P2,P3,P4,P5,P6,P7,P8,P9,P2.と並べて順番に見ていったとき、
  //0の次が1となっている場所の個数をカウントする関数f1
  //lastW=横軸の最大,lastH=縦軸の最大
  //黒=0,白=1
  public static int f1(BufferedImage readImage, int w, int h, int lastW, int lastH){
    int back_number = -1;
    int count = 0;
    int[] xpoint = {0,1,1,1,0,-1,-1,-1,0};//P2,P3,P4,P5,P6,P7,P8,P9,P2の横軸
    int[] ypoint = {-1,-1,0,1,1,1,0,-1,-1};//P2,P3,P4,P5,P6,P7,P8,P9,P2の縦軸
    for (int a = 0; a < 9; a++) {
      //画像外の画素を参照した場合
      if(w + xpoint[a] < 0 || w + xpoint[a] >= lastW ||
      h + ypoint[a] < 0 || h + ypoint[a] >= lastH){
        //back_number = 0;
        continue;
      }
      int color = readImage.getRGB(w + xpoint[a], h + ypoint[a]); // 画素値を取得
      if(color == white && back_number == 0){//色が1(白)でかつ前の画素が0(黒)ならカウント
        count++;
        back_number = 1;
      }else if(color == brack){//前画素を保存
        back_number = 0;
      }else {
        back_number = 1;
      }
    }
    return count;
  }

  //P2~P9の中の1の個数
  //黒=0,白=1
  public static int f2(BufferedImage readImage, int w, int h, int lastW, int lastH){
    int count = 0;
    int[] xpoint = {0,1,1,1,0,-1,-1,-1};
    int[] ypoint = {-1,-1,0,1,1,1,0,-1};
    for (int a = 0; a < 8; a++) {
      //画像外の画素を参照した場合
      if(w + xpoint[a] < 0 || w + xpoint[a] >= lastW ||
      h + ypoint[a] < 0 || h + ypoint[a] >= lastH){
        count++;
        continue;
      }
      int color = readImage.getRGB(w + xpoint[a], h + ypoint[a]); // 入力画像の画素値を取得
      if(color == white){
        count++;
      }
    }
    return count;
  }

  public static void check_color(BufferedImage readImage,int[] check_box, int w, int h, int lastW, int lastH){
    //[null,p1,p2,p3,p4,p5,p6,p7,p8,p9]
    int[] xpoint = {0,0,0,1,1,1,0,-1,-1,-1};
    int[] ypoint = {0,0,-1,-1,0,1,1,1,0,-1};
    for (int a = 1; a < 10; a++) {
      //画像外の画素を参照した場合
      if(w + xpoint[a] < 0 || w + xpoint[a] >= lastW ||
      h + ypoint[a] < 0 || h + ypoint[a] >= lastH){
        check_box[a] = 0;
        continue;
      }
      int color = readImage.getRGB(w + xpoint[a], h + ypoint[a]); // 入力画像の画素値を取得
      if(color == white){
        check_box[a] = 1;//白
      }else{
        check_box[a] = 0;//黒
      }
    }
  }
}//class
