using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ObstacleCollision : MonoBehaviour
{

    public GameObject player;
    public Transform characterModel;

    public AudioSource crashThud;

    public Transform mainCamera;

    public GameObject levelControl;

    public static bool didCollide = false;

    void Awake(){
        if(SceneManager.GetActiveScene().name == "GamePlay"){
        player = GameObject.Find("Player");
        mainCamera = player.transform.GetChild(1);
        characterModel = player.transform.GetChild(0);
        crashThud = GameObject.Find("LevelControl").transform.GetChild(3).GetComponent<AudioSource>();
        levelControl = GameObject.Find("LevelControl");
        }
    }
    void OnTriggerEnter(Collider other){
        didCollide = true;
        this.gameObject.GetComponent<BoxCollider>().enabled = false;
        player.GetComponent<PlayerMove>().enabled = false;
        characterModel.GetComponent<Animator>().Play("Stumble Backwards");
        levelControl.GetComponent<LevelDistance>().enabled = false;
        crashThud.Play();
        mainCamera.GetComponent<Animator>().enabled = true;
        levelControl.GetComponent<EndRunSequence>().enabled = true;
    }
}
