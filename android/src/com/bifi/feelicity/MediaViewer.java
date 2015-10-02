/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.bifi.feelicity;

import java.io.InputStream;
import java.net.URL;

import android.app.Activity;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.Toast;
import android.widget.VideoView;

public class MediaViewer extends Activity {

	/**
	 * TODO: Set the path variable to a streaming video URL or a local media
	 * file path.
	 */
	private String path = "";
	private String type = "";
	private VideoView mVideoView;
	private ImageView mImageView;

	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		setContentView(R.layout.mediaviewer);
		mVideoView = (VideoView) findViewById(R.id.video_view);
		mImageView = (ImageView) findViewById(R.id.image_view);

		Bundle extras = getIntent().getExtras();
		if (extras != null) {
			type = extras.getString("type");
			path = extras.getString("url");
		}

		if (path == "" || type == "") {
			// Tell the user to provide a media file URL/path.
			Toast.makeText(MediaViewer.this, "Error loading data",
					Toast.LENGTH_LONG).show();

		} else {

			/*
			 * Alternatively,for local media you can use
			 * mVideoView.setVideoPath(path);
			 */
			if (type.equals("video")) {
				mVideoView.setVisibility(View.VISIBLE);
				mVideoView.setVideoURI(Uri.parse(path + ".mp4"));
				mVideoView.setMediaController(new MediaController(this));
				mVideoView.requestFocus();
				mVideoView.start();
			} else {
				mImageView.setVisibility(View.VISIBLE);
				mImageView.setImageDrawable(getImage(path + ".jpg"));
			}

		}
	}

	private Drawable getImage(String url) {
		Log.d("Image URL", url);
		try {
			InputStream is = (InputStream) new URL(url).getContent();
			Drawable d = Drawable.createFromStream(is, "src name");
			return d;
		} catch (Exception e) {
			System.out.println("Exc=" + e);
			return null;
		}
	}
}