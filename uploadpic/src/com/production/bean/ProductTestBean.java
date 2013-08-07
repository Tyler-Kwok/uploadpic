package com.production.bean;

import java.io.File;
import java.util.ArrayList;
import java.util.UUID;






public class ProductTestBean {
	private String name;
	private String describe;
	private FileUploadTestBean mpf=null;
	private UUID pbid;

	public FileUploadTestBean getMpf() {
		return mpf;
	}
	public void setMpf(FileUploadTestBean mpf) {
		this.mpf = mpf;
	}
	
	public void factoryMultiPartFileUploadBean(String filedir){
		this.mpf=new FileUploadTestBean(new ArrayList<File>(), filedir);
	}
	public ProductTestBean(String filedir) {
		factoryMultiPartFileUploadBean(filedir);
	}
	
	public boolean hasMpf(){
		if(this.mpf==null)return false;
		else return true;
		
	}
	
	public ProductTestBean mergePicData(ProductTestBean data, ProductTestBean pic){
		return new ProductTestBean(data.name, data.describe, pic.mpf);
	}
	
	public ProductTestBean(String name, String describe,
			FileUploadTestBean mpf) {
		super();
		this.name = name;
		this.describe = describe;
		this.mpf = mpf;
	}
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescribe() {
		return describe;
	}
	public void setDescribe(String describe) {
		this.describe = describe;
	}
	public String printProductBean(){
		StringBuilder outstring=new StringBuilder("production name :"+ this.name);
		outstring.append("\nproduction describe: ");
		outstring.append(describe+"\n");
		if(this.mpf!=null){
			outstring.append(this.mpf.printFileNameList()+"\n");
		}else outstring.append("empty picture files\n");
		return outstring.toString();
	}
	
	
	public ProductTestBean() {
		super();
	}
	
	public ProductTestBean(UUID pbid, String realPath) {
		this.pbid=pbid;
		this.factoryMultiPartFileUploadBean(realPath);
	}
	public UUID getPbid() {
		return pbid;
	}
	public void setPbid(UUID pbid) {
		this.pbid = pbid;
	}
	
	public UUID assignID(){
		this.pbid=UUID.randomUUID();
		return this.pbid;
	}
} 
