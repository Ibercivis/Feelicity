package com.bifi.feelicity.MapTools;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.BufferedHttpEntity;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Message;

public class HttpConnection implements Runnable {

	public static final int DID_START = 0;
	public static final int DID_ERROR = 1;
	public static final int DID_SUCCEED = 2;

	private static final int GET = 0;
	private static final int POST = 1;
	private static final int PUT = 2;
	private static final int DELETE = 3;
	private static final int BITMAP = 4;

	private String url;
	private int method;
	private Handler handler;
	// private String data;
	private HttpEntity entity;

	private HttpClient httpClient;

	public HttpConnection() {
		this(new Handler());
	}

	public HttpConnection(Handler _handler) {
		handler = _handler;
	}

	public void create(int method, String url, HttpEntity entity) {
		this.method = method;
		this.url = url;
		this.entity = entity;
		ConnectionManager.getInstance().push(this);
	}

	public void get(HttpClient httpClient, String url) {
		create(GET, url, null);
		this.httpClient = httpClient;
	}

	public void post(HttpClient httpClient, String url, HttpEntity entity) {
		create(POST, url, entity);
		this.httpClient = httpClient;
	}

	public void put(String url, HttpEntity entity) {
		create(PUT, url, entity);
	}

	public void delete(String url) {
		create(DELETE, url, null);
	}

	public void bitmap(String url) {
		create(BITMAP, url, null);
	}

	public void run() {
		handler.sendMessage(Message.obtain(handler, HttpConnection.DID_START));
		HttpParams httpParameters = new BasicHttpParams();
		
		// Set the timeout in milliseconds until a connection is established.
		int timeoutConnection = 25000;
		/*HttpConnectionParams.setConnectionTimeout(httpParameters,
				timeoutConnection);*/
		// Set the default socket timeout (SO_TIMEOUT)
		// in milliseconds which is the timeout for waiting for data.
		int timeoutSocket = 25000;
		/*HttpConnectionParams.setSoTimeout(httpParameters, timeoutSocket);*/
		try {
			HttpResponse response = null;
			switch (method) {
			case GET:
				HttpGet httpGet = new HttpGet(url);
				response = httpClient.execute(httpGet);
				break;
			case POST:
				HttpPost httpPost = new HttpPost(url);
				httpPost.setEntity(entity);
				response = httpClient.execute(httpPost);
				break;
			case PUT:
				HttpPut httpPut = new HttpPut(url);
				httpPut.setEntity(entity);
				response = httpClient.execute(httpPut);
				break;
			case DELETE:
				HttpDelete httpDelete = new HttpDelete(url);
				response = httpClient.execute(new HttpDelete(url));
				break;
			case BITMAP:
				response = httpClient.execute(new HttpGet(url));
				processBitmapEntity(response.getEntity());
				break;
			}
			if (method < BITMAP)
				processEntity(response.getEntity());
		} catch (Exception e) {
			handler.sendMessage(Message.obtain(handler,
					HttpConnection.DID_ERROR, e));
		}
		ConnectionManager.getInstance().didComplete(this);
	}

	private void processEntity(HttpEntity entity) throws IllegalStateException,
			IOException {
		BufferedReader br = new BufferedReader(new InputStreamReader(
				entity.getContent()));
		String line, result = "";
		while ((line = br.readLine()) != null)
			result += line;
		Message message = Message.obtain(handler, DID_SUCCEED, result);
		handler.sendMessage(message);
	}

	private void processBitmapEntity(HttpEntity entity) throws IOException {
		BufferedHttpEntity bufHttpEntity = new BufferedHttpEntity(entity);
		Bitmap bm = BitmapFactory.decodeStream(bufHttpEntity.getContent());
		handler.sendMessage(Message.obtain(handler, DID_SUCCEED, bm));
	}

}
