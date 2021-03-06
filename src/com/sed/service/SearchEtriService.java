package com.sed.service;

import java.util.Iterator;
import java.util.Map;

import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sed.common.Define;
import com.sed.common.SimpleHTTPClient;

@Service
public class SearchEtriService {
	
	@Value("#{applicationProperties['search.etri.url']}")				private String url ;
	@Value("#{applicationProperties['http.connectionTimeoutMillis']}")	private int connectionTimeoutMillis ;
	@Value("#{applicationProperties['http.socketReadTimeoutMillis']}")	private int socketReadTimeoutMillis ;
	
	public byte[] doSearch(Map<String, String[]> params) throws Exception
	{
		SimpleHTTPClient client = new SimpleHTTPClient(url);
		client.addHeader("Accept", "text/json");// json형식으로 요청 
		client.setGet();
		client.setConnectionTimeoutMillis(connectionTimeoutMillis);
		client.setSocketReadTimeoutMillis(socketReadTimeoutMillis);
		
		Iterator<String> it = params.keySet().iterator();
		
		//전송 파라미터 세팅 
		while(it.hasNext())
		{
			String name = it.next();
			String[] valList = params.get(name);
			
			if(!ArrayUtils.isEmpty(valList))
				client.addParam(name, valList[0]);	
		}
		
		return client.exec(Define.UTF_8);
	}
}
