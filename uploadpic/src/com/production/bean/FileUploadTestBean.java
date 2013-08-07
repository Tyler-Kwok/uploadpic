
package com.production.bean;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import java.util.ArrayList;
import java.util.List;


import java.util.UUID;
 
import javax.imageio.ImageIO;


import org.springframework.web.multipart.MultipartFile;


import javax.xml.bind.DatatypeConverter;




public class FileUploadTestBean implements java.io.Serializable
{
	final static int BUFFER_SIZE = 4096;

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int defaultpicindex;

    private List<File> realfiles;
    String filedir=null;
    
    public FileUploadTestBean() {
		super();

		//this.productDir = productDir;
	}
    
	public String getFiledir() {
		return filedir;
	}

	public void setFiledir(String filedir) {
		this.filedir = filedir;
	}

    public FileUploadTestBean(List<File> realfiles, String filedir) {
		super();
		this.realfiles = realfiles;
		this.filedir = filedir;
	}

	public void setFiles(List<MultipartFile> files) throws IllegalStateException, IOException {
		delAllFile();
		defaultpicindex=0;
        saveFiles(files, filedir);
    }
    
    public void addFiles(List<MultipartFile> addfiles) throws IllegalStateException, IOException{
    	if(defaultpicindex==-1)defaultpicindex=0;

    	saveFiles(addfiles, filedir);
    	
    }
    

    public void saveFiles(List<MultipartFile> files, String dir) throws IllegalStateException, IOException{

    	for(MultipartFile f:files){
    		
    		File file;
    		System.err.println(f.getName());
    		if(f.getName().equals("inputfile.64data") || f.getName().equals("Blob")){
    			//f.getInputStream().toString();
    			file=InputSteambuildFile(f.getInputStream(), dir);
    		}else{
    			String suffix = f.getOriginalFilename().substring(f.getOriginalFilename().lastIndexOf("."));
    			String filePath = dir + File.separator + UUID.randomUUID()+suffix;
    			file= new File(filePath);
    			f.transferTo(file);
    		}
    		realfiles.add(file);

    	}
    }
    
    //don't work now, but can received picture of user draw in future.
    public static String InputStreamTOString(InputStream in) throws IOException{  
        
        ByteArrayOutputStream outStream = new ByteArrayOutputStream();  
        byte[] data = new byte[BUFFER_SIZE];  
        int count = -1;  
        while((count = in.read(data,0,BUFFER_SIZE)) != -1)  
            outStream.write(data, 0, count);  
          
        data = null;  
        return new String(outStream.toByteArray());  
    }
	
    //don't work now, but can received picture of user draw in future.
    public File InputSteambuildFile(InputStream input, String dir) throws IOException{
    	String sb=InputStreamTOString(input);
    	
		String type=sb.substring(sb.indexOf(":")+1, sb.indexOf(";"));
		String suffix;
		if(type.equals("image/jpeg"))suffix="jpg";
		else suffix=type.substring(type.length()-3);
		String data=sb.substring(sb.indexOf(",")+1);
		String filePath = dir + File.separator + UUID.randomUUID()+"."+suffix;
		File file= new File(filePath);
		
		ByteArrayInputStream baos = new ByteArrayInputStream(DatatypeConverter.parseBase64Binary(data));
	
		BufferedImage image=ImageIO.read(baos);
			
			///FileImageOutputStream fileout=new File FileImageOutputStream(f);
		ImageIO.write(image, suffix, file);
		return file;
    }
    
    public void delAllFile() throws IOException {
    	for(File f:realfiles){
    		if(!f.delete()) 
    			throw new IOException("your file name: "+f.getAbsolutePath()+
    					File.pathSeparator+f.getName()+" could not delete");
    		
    	}
    	realfiles.clear();
    	defaultpicindex=-1;
    }
    
    
    //file name equal do not include suffix
    public boolean delFile(String filename){
    	
    	for(int i=0;i<realfiles.size();i++){
    		String tmp=realfiles.get(i).getName();
    		if(tmp.substring(0, tmp.lastIndexOf(".")).equals(filename)){
    			realfiles.get(i).delete();
    			realfiles.remove(i);
    			if(this.defaultpicindex==i){
    				if(realfiles.size()==0)defaultpicindex=-1;
    				else defaultpicindex=0;
    			}
    			return true;
    		}
    	}
    	return false;
    }
    
    public String printFileNameList(){
    	StringBuilder sb=new StringBuilder("The production contain "+realfiles.size()+" files \n");
    	if(realfiles.isEmpty()){
    		sb.append("===========================================\n");
    		sb.append("empty now");
    	}else{
	    	for(File f:realfiles){
	    		sb.append("============================================\n");
	    		sb.append("file name: "+f.getName()+"\n");
	    		sb.append("file Space taken: "+f.getUsableSpace()+" bytes\n");
	    		
	    		//sb.append("current name:"+f.getContentType()+"\n");
	    		
	    	}
    	}
    	return sb.toString();    
    }
    
    public int size(){
    	return this.realfiles.size();
    }

	public int getDefaultpicIndex() {
		
		return defaultpicindex;
	}

	public boolean setDefaultFile(String filename) {
		int i=0;	
		for(File f:realfiles){
				String tmp=f.getName();
				if(tmp.substring(0, tmp.lastIndexOf(".")).equals(filename)){
					defaultpicindex=i;
					return true;
				}
				i++;
			}
		return false;
	}
   
	public String getDefaultFileName(){
		return realfiles.get(defaultpicindex).getName();
	}
	


	public List<File> getRealfiles() {
		return realfiles;
	}

	public void setRealfiles(List<File> realfiles) {
		this.realfiles = realfiles;
	}
    
	
	public String getIndexfilename(int i){
		if(i>=0 && i<this.realfiles.size()){
			return realfiles.get(i).getName();
		}
		return null;
	}
   
}