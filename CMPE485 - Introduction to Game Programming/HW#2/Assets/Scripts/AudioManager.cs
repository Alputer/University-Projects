using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    
    public static AudioManager instance;
    public AudioSource myAudio;
    

    private void Awake(){
        instance = this;
    }

    public void TurnOffAudio(){
        this.myAudio.gameObject.SetActive(false);
    }

    public void TurnOnAudio(){
        this.myAudio.gameObject.SetActive(true);
    }

}
