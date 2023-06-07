using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EndRunSequence : MonoBehaviour
{

    public GameObject liveCoins;
    public GameObject liveDistance;
    public GameObject endScreen;

    public GameObject fadeOut;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(endSequence());
    }

    IEnumerator endSequence(){
        yield return new WaitForSeconds(2f);
        liveCoins.SetActive(false);
        liveDistance.SetActive(false);
        endScreen.SetActive(true);
        yield return new WaitForSeconds(3f);
        fadeOut.SetActive(true);
        yield return new WaitForSeconds(2.5f);
        SceneManager.LoadScene("MainMenu");

    }
}
