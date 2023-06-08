using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelStart : MonoBehaviour
{

    public GameObject countDown3;
    public GameObject countDown2;
    public GameObject countDown1;
    public GameObject countDownGo;
    public GameObject fadeIn;

    public AudioSource readyFX;
    public AudioSource goFX;

    public GameObject levelControl;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(countDown());
    }

    IEnumerator countDown(){
        yield return new WaitForSeconds(1f);
        readyFX.Play();
        countDown3.SetActive(true);
        yield return new WaitForSeconds(1.2f);
        readyFX.Play();
        countDown2.SetActive(true);
        yield return new WaitForSeconds(1.2f);
        readyFX.Play();
        countDown1.SetActive(true);
        yield return new WaitForSeconds(1.2f);
        goFX.Play();
        countDownGo.SetActive(true);
        levelControl.GetComponent<LevelDistance>().enabled = true;
        PlayerMove.canMove = true;
    }
}
