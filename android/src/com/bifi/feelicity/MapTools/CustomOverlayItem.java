package com.bifi.feelicity.MapTools;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.OverlayItem;

public class CustomOverlayItem extends OverlayItem {
	
	public String id = "";
	public String type = "place";

	public CustomOverlayItem(GeoPoint point, String title, String snippet) {
		super(point, title, snippet);
		// TODO Auto-generated constructor stub
	}
	
	public CustomOverlayItem(GeoPoint point, String title, String snippet, String type) {
		super(point, title, snippet);
		// TODO Auto-generated constructor stub
		this.type = type;
	}
	
	public CustomOverlayItem(GeoPoint point, String title, String snippet, String id, String type) {
		super(point, title, snippet);
		// TODO Auto-generated constructor stub
		this.id = id;
		this.type = type;
	}
	
	public String getType() {
		return type;
	}
	
	public String getId() {
		return id;
	}

}
