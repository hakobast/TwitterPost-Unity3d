using UnityEngine;
using System.Collections;
using System;

public class TwitterTest : MonoBehaviour {

	public Texture2D textureToPost;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void OnGUI()
	{
		if(GUI.Button(new Rect(200,200,200,200),"POST IMAGE"))
		{
			TwitterAPI.Tweet(textureToPost.EncodeToJPG(),"My Awesome tweet with Image","google.com");
		}

		if(GUI.Button(new Rect(200,500,200,200),"POST"))
		{
			TwitterAPI.Tweet("My Awesome tweet from Unity");
		}
	}
}
