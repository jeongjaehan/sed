package com.sed.controller;

import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sed.common.Define;
import com.sed.service.SearchEtriService;


@Controller
@RequestMapping("/apis/search/etri")
public class SearchEtriController {

	/**
	 * 로거
	 */
	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired SearchEtriService searchEtriService;
	@Autowired MessageSourceAccessor messageSourceAccessor;

	@RequestMapping(method=RequestMethod.GET)
	public void  searchImin(HttpServletRequest request, HttpServletResponse response , ServletOutputStream out)throws Exception
	{
		Map<String, String[]> params = request.getParameterMap();

		byte[]  resultSring= searchEtriService.doSearch(params);
		logger.info("jsonObject : {}",new String(resultSring));

	}
	
	/**
	 * Exception 처리 
	 * @param e
	 * @param request
	 * @param response
	 */
	@ExceptionHandler(Exception.class)
	public void handleException(Exception e, HttpServletRequest request, HttpServletResponse response){
		try {
			String errorXml = messageSourceAccessor.getMessage("error.api.search.unkownerror.xml");
			response.getOutputStream().write(errorXml.getBytes(Define.UTF_8));
		} catch (Exception ex) {
			logger.error(ex.getMessage(),ex);
			ex.printStackTrace();
		}
	}
}
