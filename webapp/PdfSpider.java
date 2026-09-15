import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;

public class PdfSpider {

    public static void main(String[] args) {

        try {

            String pdfUrl =
            "https://www.gutenberg.org/files/1342/1342-pdf.pdf";

            String savePath =
            "C:/jsp/apache-tomcat-11.0.18/webapps/library/books/book1.pdf";

            URL url = new URL(pdfUrl);

            InputStream in = url.openStream();

            FileOutputStream out = new FileOutputStream(savePath);

            byte[] buffer = new byte[1024];

            int length;

            while ((length = in.read(buffer)) != -1) {

                out.write(buffer, 0, length);

            }

            in.close();
            out.close();

            System.out.println("下载完成");

        } catch (Exception e) {

            e.printStackTrace();

        }

    }
}