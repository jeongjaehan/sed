package com.sed.controller;

import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sed.service.SearchIminService;


@Controller
@RequestMapping("/search/imin")
public class SearchIminController {
	/**
	 * 로거
	 */
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired SearchIminService searchIminService;
	
	@RequestMapping(method=RequestMethod.GET)
	public JSONObject searchIminAPI(HttpServletRequest request, HttpServletResponse response , ServletOutputStream out)throws Exception
	{
		Map<String, String[]> params = request.getParameterMap();
		
		JSONObject returnJson = searchIminService.doSearch(params);
		logger.debug("jsonObject : {}",returnJson);
		return returnJson;

	}
}
