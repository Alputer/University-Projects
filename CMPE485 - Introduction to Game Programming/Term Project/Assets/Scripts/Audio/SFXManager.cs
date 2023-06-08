using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SFXManager : MonoBehaviour
{

    public static SFXManager instance;

    public AudioSource coinSound;

        void Awake(){

        
        if(instance != null){
            Destroy(this);
            return;
        }

        instance = this;
        DontDestroyOnLoad(this);
    }

    public void playCoinSound(){
        coinSound.Stop();

        coinSound.pitch = Random.Range(0.8f, 1.2f);

        coinSound.Play();

        

    }
}
