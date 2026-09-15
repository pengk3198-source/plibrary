import java.util.*;

public class CircleArea {
    public static void main(String[] args) {

        double radius;
        double area;
        Scanner input = new Scanner(System.in);
        System.out.print("반지름을 입력하세요.");
        radius = input.nextDouble();
        area = 3.14 * radius * radius;

        System.out.println(area);

    }
}
