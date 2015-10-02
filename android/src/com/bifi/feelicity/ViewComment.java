package com.bifi.feelicity;

import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.Gallery;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;

import com.bifi.feelicity.MapTools.HttpConnection;

public class ViewComment extends Activity {

	private Activity _this = this;

	CustomApp appState;
	Resources res;

	String placeName;
	JSONObject comment;
	
	ProgressDialog progressDialog;
	
	public static final int POSITIVE_SCORING = 1;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		appState = ((CustomApp) getApplicationContext());
		res = getResources();

		try {
			Bundle extras = getIntent().getExtras();
			if (extras != null) {
				placeName = extras.getString("place_name");
				comment = new JSONObject(extras.getString("comment"));
			}

			setContentView(R.layout.viewcomment);

			showData(comment);

		} catch (Exception e) {
			System.out.println("Exc=" + e);
		}
	}
	
	public void getData(){
		progressDialog = ProgressDialog.show(ViewComment.this, "", res.getString(R.string.msg_loading) + "...", true, true);
		
		Handler handler = new Handler() {
			public void handleMessage(Message message) {
				switch (message.what) {
				case HttpConnection.DID_START: {
					Log.d("HttpConnection", "Starting Connection");
					break;
				}
				case HttpConnection.DID_SUCCEED: {
					progressDialog.cancel();
					try {
						Log.d("HttpConnection", "Connection Success");
						JSONObject jsonResponse = new JSONObject(
								(String) message.obj);
						if (jsonResponse.get("status").toString().equals("OK")) {
							showData(jsonResponse.getJSONObject("comment"));
						} else {
							AlertDialog.Builder builder = new AlertDialog.Builder(
									_this);
							builder.setMessage(
									jsonResponse.get("message").toString())
									.setCancelable(false)
									.setPositiveButton(
											"OK",
											new DialogInterface.OnClickListener() {
												public void onClick(
														DialogInterface dialog,
														int id) {
													dialog.cancel();
												}
											});
							AlertDialog alert = builder.create();
							alert.show();
						}
					} catch (Exception e) {
						e.printStackTrace();

					} finally {
					}

					break;
				}
				case HttpConnection.DID_ERROR: {
					Log.d("HttpConnection", "Connection Error");
					Exception e = (Exception) message.obj;
					e.printStackTrace();
					break;
				}
				}
			}
		};

		try {
			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
			nameValuePairs.add(new BasicNameValuePair("id", comment.getString("comment_id")));
			new HttpConnection(handler).post(appState.getHttpClient(), appState.getServerString()
					+ "/view/get_comment_data", new UrlEncodedFormEntity(
					nameValuePairs, "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
		}
	}
	
	public void showData(JSONObject data) throws JSONException {
		TextView title = (TextView) findViewById(R.id.title);
		if (!data.getString("comment_title").equals("null")) {
			title.setText(data.getString("comment_title"));
		} else {
			title.setText(placeName);
		}

		TextView details = (TextView) findViewById(R.id.details);
		details.setText(data.getString("created_on") + " " + res.getString(R.string.msg_by) + " "
				+ data.getString("user_name"));

		Button positiveScorings = (Button) findViewById(R.id.positive_scorings);
		positiveScorings.setText(Integer.toString(data
				.getInt("positive_scorings")));
		
		positiveScorings.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				if (appState.logged) {
					addScoring(POSITIVE_SCORING);
				} else {
					AlertDialog.Builder builder = new AlertDialog.Builder(
							_this);
					builder.setMessage(
							res.getString(R.string.msg_you_must_login))
							.setCancelable(false)
							.setPositiveButton(
									res.getString(R.string.btn_login),
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog,
												int id) {
											Intent myIntent = new Intent(
													_this,
													Login.class);
											startActivityForResult(
													myIntent,
													0);
										}
									})
							.setNegativeButton(
									res.getString(R.string.btn_close),
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog,
												int id) {
											dialog.cancel();
										}
									});
					AlertDialog alert = builder
							.create();
					alert.show();
				}
			}
		});

		TextView content = (TextView) findViewById(R.id.content);
		content.setText(data.getString("comment_content"));

		final JSONArray jsonAttachments = data.getJSONArray("files");

		Gallery g = (Gallery) findViewById(R.id.attachments);
		g.setAdapter(new ImageAdapter(this, jsonAttachments));

		g.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView parent, View v,
					int position, long id) {
				try {
					final JSONObject attachment = jsonAttachments
							.getJSONObject(position);
					
					if (attachment.getString("type").equals("youtube")) {
						String youtubeId = getYoutubeId(jsonAttachments
								.getJSONObject(position).getString("path"));

						if (youtubeId.length() > 0) {
							Handler handler = new Handler() {
								public void handleMessage(Message message) {
									switch (message.what) {
									case HttpConnection.DID_START: {
										Log.d("HttpConnection",
												"Starting Connection");
										break;
									}
									case HttpConnection.DID_SUCCEED: {
										try {
											Log.d("HttpConnection",
													"Connection Success");
											JSONObject jsonResponse = new JSONObject(
													(String) message.obj);
											
											Intent myIntent = new Intent(_this, MediaViewer.class);
											myIntent.putExtra("type", attachment.getString("type"));
											myIntent.putExtra("url", jsonResponse
													.getJSONObject("feed")
													.getJSONArray("entry")
													.getJSONObject(0)
													.getJSONObject(
															"media$group")
													.getJSONArray(
															"media$content")
													.getJSONObject(0)
													.getString("url"));
											(_this).startActivityForResult(myIntent, 0);
										} catch (Exception e) {
											e.printStackTrace();

										} finally {
										}

										break;
									}
									case HttpConnection.DID_ERROR: {
										Log.d("HttpConnection",
												"Connection Error");
										Exception e = (Exception) message.obj;
										e.printStackTrace();
										break;
									}
									}
								}
							};

							try {
								new HttpConnection(handler).get(
										appState.getHttpClient(),
										"http://gdata.youtube.com/feeds/api/videos?q="
												+ youtubeId + "&alt=json");
							} catch (Exception e) {
								e.printStackTrace();
							} finally {
							}
						}
					} else {
						Intent myIntent = new Intent(_this, MediaViewer.class);
						myIntent.putExtra("type", attachment.getString("type"));
						myIntent.putExtra("url", appState.getServerString()
								+ attachment.getString("path"));
						(_this).startActivityForResult(myIntent, 0);
					}
				} catch (Exception e) {

				}
			}
		});
	}

	private void addScoring(final int value) {
		progressDialog = ProgressDialog.show(ViewComment.this, "",
				res.getString(R.string.msg_sending_vote), true,
				true);
		
		Handler handler = new Handler() {
			public void handleMessage(Message message) {
				switch (message.what) {
				case HttpConnection.DID_START: {
					Log.d("HttpConnection", "Starting Connection");
					break;
				}
				case HttpConnection.DID_SUCCEED: {

					try {
						Log.d("HttpConnection", "Connection Success");
						JSONObject jsonResponse = new JSONObject(
								(String) message.obj);
						String alertMessage = new String();
						progressDialog.cancel();
						if (jsonResponse.get("status").toString().equals("OK")) {
							alertMessage = res.getString(R.string.msg_vote_saved_successfully);
							getData();
						} else {
							alertMessage = jsonResponse.get("message").toString();
						}
						AlertDialog.Builder builder = new AlertDialog.Builder(
								_this);
						builder.setMessage(
								alertMessage)
								.setCancelable(false)
								.setPositiveButton(
										"OK",
										new DialogInterface.OnClickListener() {
											public void onClick(
													DialogInterface dialog,
													int id) {
												dialog.cancel();
											}
										});
						AlertDialog alert = builder.create();
						alert.show();
					} catch (Exception e) {
						e.printStackTrace();

					} finally {
					}

					break;
				}
				case HttpConnection.DID_ERROR: {
					Log.d("HttpConnection", "Connection Error");
					Exception e = (Exception) message.obj;
					e.printStackTrace();
					break;
				}
				}
			}
		};

		try {
			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
			nameValuePairs.add(new BasicNameValuePair("comment_id", comment.getString("comment_id")));
			nameValuePairs.add(new BasicNameValuePair("value", Integer
					.toString(value)));
			new HttpConnection(handler).post(appState.getHttpClient(), appState.getServerString()
					+ "/view/add_comment_scoring", new UrlEncodedFormEntity(
					nameValuePairs, "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();

		} finally {
		}
	}

	private Drawable getImage(String url) {
		try {
			InputStream is = (InputStream) new URL(url).getContent();
			Drawable d = Drawable.createFromStream(is, "src name");
			return d;
		} catch (Exception e) {
			System.out.println("Exc=" + e);
			return null;
		}
	}

	public class ImageAdapter extends BaseAdapter {
		int mGalleryItemBackground;
		private Context mContext;

		private JSONArray jsonAttachments;

		public ImageAdapter(Context c, JSONArray jsonAttachments) {
			mContext = c;
			this.jsonAttachments = jsonAttachments;
			TypedArray a = obtainStyledAttributes(R.styleable.HelloGallery);
			mGalleryItemBackground = a.getResourceId(
					R.styleable.HelloGallery_android_galleryItemBackground, 0);
			a.recycle();
		}

		public int getCount() {
			return jsonAttachments.length();
		}

		public Object getItem(int position) {
			return position;
		}

		public long getItemId(int position) {
			return position;
		}

		public View getView(int position, View convertView, ViewGroup parent) {
			RelativeLayout l = new RelativeLayout(mContext);
			l.setLayoutParams(new Gallery.LayoutParams(320, 240));
			
			Drawable image;
			ImageView i = new ImageView(mContext);

			try {
				String attachmentType = jsonAttachments.getJSONObject(position).getString("type");
				
				if (attachmentType.equals("youtube")) {
					String youtubeId = getYoutubeId(jsonAttachments.getJSONObject(position).getString(
							"path"));

					if (youtubeId.length() > 0) {
						image = getImage("http://i.ytimg.com/vi/" + youtubeId + "/0.jpg");
						i.setImageDrawable(image);
					}
						
				} else {
					image = getImage(appState.getServerString()
							+ jsonAttachments.getJSONObject(position).getString(
									"path") + ".jpg");
					i.setImageDrawable(image);
				}
				
				RelativeLayout.LayoutParams imageLayoutParams = new RelativeLayout.LayoutParams(
						LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT);
				imageLayoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
				i.setScaleType(ImageView.ScaleType.FIT_XY);
				i.setBackgroundResource(mGalleryItemBackground);
				l.addView(i, imageLayoutParams);

				if (attachmentType.equals("video") || attachmentType.equals("youtube")) {
					i.setAlpha(50);

					ImageView videoButton = new ImageView(mContext);
					videoButton
							.setImageResource(android.R.drawable.ic_media_play);
					RelativeLayout.LayoutParams playLayoutParams = new RelativeLayout.LayoutParams(
							LayoutParams.WRAP_CONTENT,
							LayoutParams.WRAP_CONTENT);
					playLayoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
					l.addView(videoButton, playLayoutParams);
				}
			} catch (Exception e) {
				System.out.println("Exc=" + e);
				return null;
			}
			return l;
		}
	}
	
	private String getYoutubeId(String url) {
		Pattern p = Pattern.compile("http.*\\?v=([a-zA-Z0-9_\\-]+)(?:&.)*");
		Matcher m = p.matcher(url);
		
		String youtube_id = new String();

		if (m.matches()) {
			youtube_id = m.group(1); // Access a submatch group; String can't do this.
		}
		return youtube_id;
	}

}
