package com.bifi.feelicity;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;

public class YoutubePicker extends Activity {

	private Activity _this = this;
	Resources res;
	EditText youtube_url;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.youtube_picker);

		getWindow().setFlags(WindowManager.LayoutParams.FLAG_BLUR_BEHIND,
				WindowManager.LayoutParams.FLAG_BLUR_BEHIND);
		
		res = getResources();

		youtube_url = (EditText) findViewById(R.id.youtube_url);

		Button btnOK = (Button) findViewById(R.id.btn_ok);
		btnOK.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				Intent intent = new Intent();

				Pattern p = Pattern.compile("https?:\\/\\/(?:[a-zA_Z]{2,3}.)?(?:youtube\\.com\\/watch\\?)((?:[\\w\\d\\-\\_\\=]+&amp;(?:amp;)?)*v(?:&lt;[A-Z]+&gt;)?=([0-9a-zA-Z\\-\\_]+))");
				Matcher m = p.matcher(youtube_url.getText().toString());
				if (m.find()) { // Find each match in turn; String can't do
								// this.
					//String url = m.group(); // Access a submatch group; String
											// can't
											// do this.
					intent.putExtra("url", youtube_url.getText().toString());
					setResult(RESULT_OK, intent);
					finish();
				} else {
					AlertDialog.Builder builder = new AlertDialog.Builder(_this);
					builder.setMessage(res.getString(R.string.msg_incorrect_youtube_link))
							.setCancelable(false)
							.setPositiveButton("OK",
									new DialogInterface.OnClickListener() {
										public void onClick(DialogInterface dialog,
												int id) {
											dialog.cancel();
										}
									});
					AlertDialog alert = builder.create();
					alert.show();
				}
			}
		});

		Button btnCancel = (Button) findViewById(R.id.btn_cancel);
		btnCancel.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				Intent intent = new Intent();
				setResult(RESULT_CANCELED, intent);
				finish();
			}
		});
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			Intent intent = new Intent();
			setResult(RESULT_CANCELED, intent);
		}
		return super.onKeyDown(keyCode, event);
	}
}
