package com.production.utils;

//import com.sun.image.codec.jpeg.ImageFormatException;
//import com.sun.image.codec.jpeg.JPEGCodec;
//import com.sun.image.codec.jpeg.JPEGImageEncoder;
//import ix.houseware.category.web.controller.CategoryImageController;
//import java.awt.image.BufferedImage;
//import java.io.ByteArrayOutputStream;
//import java.io.IOException;
//import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.imageio.ImageIO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author sam
 */
public class ImageUtils {
    private static final Logger logger = LoggerFactory.getLogger(ImageUtils.class);
    
    public ImageUtils() {
        throw new RuntimeException("Compiled Code");
    }
    

    public static byte[] bufferedImageToByteArray(BufferedImage img) throws IOException {
//        byte[] imageBytes = ((DataBufferByte) img.getData().getDataBuffer()).getData();
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write( img, "jpg", baos );
        baos.flush();
        byte[] imageInByte = baos.toByteArray();
        baos.close();
        return imageInByte;
	}
    
    public static void SaveFileFromInputStream(InputStream stream,String pathfile) throws IOException   
    {         
        FileOutputStream fs=new FileOutputStream( pathfile);   
        byte[] buffer =new byte[1024*1024];   
        int bytesum = 0;   
        int byteread = 0;    
        while ((byteread=stream.read(buffer))!=-1)   
        {   
           bytesum+=byteread;   
           fs.write(buffer,0,byteread);   
           fs.flush();   
        }    
        fs.close();   
        stream.close();         
    } 
    
//    public static byte[] toByteArray(BufferedImage bufImage, String fName) throws IOException {
//        ByteArrayOutputStream baos = new ByteArrayOutputStream();
//        ImageIO.write(bufImage, fName, baos);
//        byte[] bytesOut = baos.toByteArray();
//        logger.debug("===bufImage: "+bufImage.toString());
//        logger.debug("===bytesOut: "+bytesOut.length);
//        return bytesOut;
//    }
}
