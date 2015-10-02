package com.bifi.feelicity.MapTools;

import java.util.ArrayList;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;

import com.bifi.feelicity.R;
import com.bifi.feelicity.ViewPlace;
import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.MapActivity;

public class MapItemizedOverlay extends ItemizedOverlay<CustomOverlayItem> {

	private ArrayList<CustomOverlayItem> mOverlays = new ArrayList<CustomOverlayItem>();
	private Context mContext;
	
	Resources res;

	public MapItemizedOverlay(Drawable defaultMarker, Context context) {
		super(boundCenterBottom(defaultMarker));
		mContext = context;
		
		res = context.getResources();
	}

	@Override
	protected CustomOverlayItem createItem(int i) {
		return mOverlays.get(i);
	}

	@Override
	public int size() {
		return mOverlays.size();
	}

	public void addOverlay(CustomOverlayItem overlay) {
		mOverlays.add(overlay);
		populate();
	}
	
	public void addOverlays(ArrayList<CustomOverlayItem> overlays) {
		for (int i=0; i<overlays.size(); i++) {
			mOverlays.add(overlays.get(i));
		}
		populate();
	}

	@Override
	protected boolean onTap(int index) {
		final CustomOverlayItem item = mOverlays.get(index);

		AlertDialog.Builder dialog = new AlertDialog.Builder(mContext);
		dialog.setTitle(item.getTitle());
		dialog.setMessage(item.getSnippet());
		dialog.setCancelable(false);
		if (item.getType().equals("place")) {
			dialog.setPositiveButton(res.getString(R.string.btn_view),
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int id) {
							Intent myIntent = new Intent(mContext,
									ViewPlace.class);
							myIntent.putExtra("id", item.getId());
							((MapActivity) mContext).startActivityForResult(myIntent, 0);
						}
					});
		}
		dialog.setNegativeButton(res.getString(R.string.btn_close),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int id) {
						dialog.cancel();
					}
				});
		dialog.show();
		return true;
	}

}
