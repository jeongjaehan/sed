package com.sed.controller;

import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sed.common.Define;
import com.sed.service.SearchIminService;
import com.sed.service.SearchOllehMapService;


@Controller
@RequestMapping("/apis/search/ollehmap")
public class SearchOllehMapController {
	/**
	 * 로거
	 */
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired SearchOllehMapService searchOllehMapService;
	@Autowired MessageSourceAccessor messageSourceAccessor;
	
	@RequestMapping(method=RequestMethod.GET)
	public JSONObject searchOllemap(HttpServletRequest request, HttpServletResponse response , ServletOutputStream out)throws Exception
	{
		Map<String, String[]> params = request.getParameterMap();
		
		JSONObject returnJson = searchOllehMapService.doSearch(params);
		logger.info("jsonObject : {}",returnJson);
		return returnJson;
	}


	/**
	 * Exception 처리 
	 * @param e
	 * @param request
	 * @param response
	 */
	@ExceptionHandler(Exception.class)
	public JSONObject handleException(Exception e, HttpServletRequest request, HttpServletResponse response){
		JSONObject retJsonObj = null;
		try {
			String errorJson = messageSourceAccessor.getMessage("error.api.search.unkownerror");
			retJsonObj = JSONObject.fromObject(errorJson.toString());
		} catch (Exception ex) {
			logger.error(ex.getMessage(),ex);
			ex.printStackTrace();
		}
		return retJsonObj;
	}
}
