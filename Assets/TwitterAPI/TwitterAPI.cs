using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
using System;
using System.Collections.Generic;

public class TwitterAPI : MonoBehaviour
{
#if UNITY_IPHONE
	[DllImport("__Internal")]
	private static extern void _postTweet(string text, string url, string img,string delegateName);

	[DllImport("__Internal")]
	private static extern void _init(string gameObject);
#elif UNITY_ANDROID
	private static AndroidJavaClass androidBridge;
#endif

	private static GameObject twitterObj;

	public Action<TwitterResponse> onTweetComplete;

	void Start()
	{
		
	}

	public static void Tweet(string text, string url="")
	{
		Debug.Log("::C#:: Twitting:: " + text);
		if(twitterObj == null)
		{
			Init();
		}

		Debug.Log("OBJ " + twitterObj.name);

#if UNITY_EDITOR
		Debug.Log("Editor Twitter Post");
#elif UNITY_IPHONE
		_postTweet(text,url,null,"OBJTweetComplete");
#elif UNITY_ANDROID
		androidBridge.CallStatic("_postTweet",text,url,new byte[]{},"OBJTweetComplete");
#endif
	}

	public static void Tweet(byte[] img, string text = "", string url="")
	{
		Debug.Log("::C#:: Twitting Image:: " + text);
		
		if(twitterObj == null)
		{
			Init();
		}

#if UNITY_EDITOR
		Debug.Log("Editor Twitter Post Image");
#elif UNITY_IPHONE
		_postTweet(text,url,System.Convert.ToBase64String(img),"OBJTweetComplete");
#elif UNITY_ANDROID
		androidBridge.CallStatic("_postTweet",text,url,img,"OBJTweetComplete");
#endif

	}

	private static void Init()
	{
		if(twitterObj == null)
		{
			twitterObj = new GameObject("_twitterObj");
			twitterObj.AddComponent<TwitterAPI>();
		}

#if UNITY_EDITOR
		Debug.Log("Editor Twitter Inited");
#elif UNITY_IPHONE
		_init(twitterObj.name);
#elif UNITY_ANDROID_API
		AndroidJNI.AttachCurrentThread();
		androidBridge = new AndroidJavaClass("com.example.mytestapplication.MainActivity");
		androidBridge.CallStatic("_init",twitterObj.name);
#endif

	}

	private void OBJTweetComplete(string result)
	{
		TwitterResponse response = new TwitterResponse(result);
		if(onTweetComplete != null)
			onTweetComplete(response);

		Debug.Log("::C#:: Result " + response);
	}

	public class TwitterResponse
	{
		public bool complete;
		public string message;
		public string tweetText;

		public TwitterResponse(string response)
		{
			string[] res = response.Split(new char[]{','});

			complete = int.Parse(res[0]) == 1;
			message = res[1];
			tweetText = res[2];
		}

		public override string ToString ()
		{
			return "Is complete: " + complete + " Msg: " + message + " Tweet: " + tweetText;
		}
	}
}