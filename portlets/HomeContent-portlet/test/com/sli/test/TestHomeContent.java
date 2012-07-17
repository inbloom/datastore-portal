package com.sli.test;

import java.net.MalformedURLException;
import java.net.URISyntaxException;

import junit.framework.TestCase;

import org.junit.Test;
import org.slc.sli.api.client.Entity;
import org.slc.sli.api.client.EntityCollection;
import org.slc.sli.api.client.Link;
import org.slc.sli.api.client.impl.transform.BasicLinkJsonTypeAdapter;
import org.slc.sli.api.client.impl.transform.GenericEntityFromJson;
import org.slc.sli.api.client.impl.transform.GenericEntityToJson;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

public class TestHomeContent extends TestCase{

	private String jsonContent = "{\"homeText\" : \"welcome to home page\"}";
	String homeText;
	
	@Test
	public void testHomeText() throws MalformedURLException, URISyntaxException{
		EntityCollection collection = new EntityCollection();
		getResource(collection, jsonContent);
		homeText = String.valueOf((String)collection.get(0).getData().get("homeText"));
		_log.info("home text - - "+homeText);
		assertEquals("welcome to home page",homeText);
	}
	
	
	public EntityCollection getResource(EntityCollection entities,String json)
		    throws MalformedURLException, URISyntaxException {
		
		Gson gson = new GsonBuilder().setPrettyPrinting().registerTypeAdapter(Entity.class, new GenericEntityFromJson())
                .registerTypeAdapter(Entity.class, new GenericEntityToJson())
                .registerTypeAdapter(Link.class, new BasicLinkJsonTypeAdapter()).create();
		
				_log.info("json  reader...........*******"+json);
		    try {
		        JsonElement element = gson.fromJson(json, JsonElement.class);
		
		        if (element instanceof JsonArray) {
		            entities.fromJsonArray(element.getAsJsonArray());
		
		        } else if (element instanceof JsonObject) {
		            Entity entity = gson.fromJson(element, Entity.class);
		            entities.add(entity);
		        } 
		    } catch (JsonSyntaxException e) {
		   _log.info("error occured....");    
		    }
		// }
		return entities;
		}
	
	private static Log _log = LogFactoryUtil.getLog(TestHomeContent.class);
}
