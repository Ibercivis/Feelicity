package com.bifi.feelicity;

import java.util.ArrayList;
import java.util.Random;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

import com.bifi.feelicity.MapTools.ParcelableAttachment;

public class UploadFiles extends Activity {
	LinearLayout filesLayout;

	protected static final int PICK_IMAGE = 0;
	protected static final int PICK_VIDEO = 1;

	public final static int SUCCESS_RETURN_CODE = 1;

	ArrayList<ParcelableAttachment> attachmentsArray = new ArrayList<ParcelableAttachment>();

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.uploadfiles);

		filesLayout = (LinearLayout) findViewById(R.id.files);

		Bundle extras = getIntent().getExtras();
		ArrayList<ParcelableAttachment> tmpAttachmentsArray = extras.getParcelableArrayList("attachmentsArray");
		
		for (int i=0; i<tmpAttachmentsArray.size(); i++) {
			ParcelableAttachment tmpAttachment = tmpAttachmentsArray.get(i);
			addAttachment(tmpAttachment.getPath(), tmpAttachment.getType());
		}

		Button addImage = (Button) findViewById(R.id.add_image);
		addImage.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
				intent.setType("image/*");
				startActivityForResult(intent, PICK_IMAGE);
			}
		});

		Button addVideo = (Button) findViewById(R.id.add_video);
		addVideo.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				Intent i = new Intent(UploadFiles.this, YoutubePicker.class);
				startActivityForResult(i, PICK_VIDEO);
			}
		});
	}

	public void addAttachment(final String filePath, String type) {

		int randInt = new Random().nextInt();

		final RelativeLayout attachmentLayout = new RelativeLayout(this);
		RelativeLayout.LayoutParams attachmentParams = new RelativeLayout.LayoutParams(
				LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT);
		attachmentLayout.setLayoutParams(attachmentParams);

		filesLayout.addView(attachmentLayout);

		Button delete = new Button(this);
		delete.setId(randInt);
		RelativeLayout.LayoutParams deleteParams = new RelativeLayout.LayoutParams(
				LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		deleteParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
		delete.setLayoutParams(deleteParams);
		delete.setCompoundDrawablesWithIntrinsicBounds(
				android.R.drawable.ic_menu_delete, 0, 0, 0);

		attachmentLayout.addView(delete);

		EditText path = new EditText(this);
		RelativeLayout.LayoutParams pathParams = new RelativeLayout.LayoutParams(
				LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT);
		pathParams.addRule(RelativeLayout.CENTER_VERTICAL);
		pathParams.addRule(RelativeLayout.LEFT_OF, delete.getId());
		path.setLayoutParams(pathParams);

		path.setText(filePath);
		path.setEnabled(false);
		
		attachmentLayout.addView(path);

		final ParcelableAttachment attachment = new ParcelableAttachment(filePath, type);
		attachmentsArray.add(attachment);
		
		delete.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				filesLayout.removeView(attachmentLayout);
				attachmentsArray.remove(attachment);
			}
		});
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			Intent intent = new Intent();
			intent.putParcelableArrayListExtra("attachmentsArray", attachmentsArray);
			setResult(SUCCESS_RETURN_CODE, intent);
		}
		return super.onKeyDown(keyCode, event);
	}

	protected void onActivityResult(int requestCode, int resultCode,
			Intent returnedIntent) {
		super.onActivityResult(requestCode, resultCode, returnedIntent);

		if (resultCode == RESULT_OK) {

			if (requestCode == PICK_IMAGE) {
				Uri selectedImage = returnedIntent.getData();
				String[] filePathColumn = { MediaStore.Images.Media.DATA };

				Cursor cursor = getContentResolver().query(selectedImage,
						filePathColumn, null, null, null);
				cursor.moveToFirst();

				int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
				String filePath = cursor.getString(columnIndex); // file path of
																	// selected
																	// image
				cursor.close();

				Log.d("File path", filePath);
				addAttachment(filePath, "image");
			} else {
				Log.d("Youtube URL", returnedIntent.getExtras().getString("url"));
				addAttachment(returnedIntent.getExtras().getString("url"), "youtube");
			}

			/*
			 * // Convert file path into bitmap image using below line. Bitmap
			 * yourSelectedImage = BitmapFactory.decodeFile(filePath);
			 * 
			 * // put bitmapimage in your imageview
			 * yourimgView.setImageBitmap(yourSelectedImage);
			 */
		}
	}
}
