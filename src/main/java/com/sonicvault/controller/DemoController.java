package com.sonicvault.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DemoController {
	
	@GetMapping("/hello")
	public String sayHello(Map<String,String> map) {
		
		map.put("msg","HelloWorld");
		return "helloworld";
	}

}
