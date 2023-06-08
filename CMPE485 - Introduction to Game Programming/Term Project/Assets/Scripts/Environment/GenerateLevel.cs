using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GenerateLevel : MonoBehaviour
{

    public GameObject environment;

    public GameObject[] obstacles;

    public GameObject coin;
    public int zPos = 55;

    public int index = 1;

    public bool creatingSection = false;

    public GameObject lastSpawnedObject;


    // Update is called once per frame
    void Update()
    {

        if(!creatingSection){
            creatingSection = true;
            StartCoroutine(GenerateSection());
        }
        
    }

    IEnumerator GenerateSection(){

        GameObject lastSectionSpawned = new GameObject($"Section {index++}");
        
        lastSpawnedObject = Instantiate(environment, new Vector3(0,0, zPos), Quaternion.identity);
        lastSpawnedObject.transform.SetParent(lastSectionSpawned.transform);

        float lastLogIndex = -1;
        for(int i=0;i<50;i++){
            int gamble1 = Random.Range(0,10);
            if(gamble1 < 4){
                int gamble2 = Random.Range(0,20);
                if(gamble2 < 5){
                lastSpawnedObject = Instantiate(obstacles[0], new Vector3(Random.Range(-4.2f, 4.2f), 2f, zPos + i), Quaternion.identity);
                lastSpawnedObject.transform.SetParent(lastSectionSpawned.transform);
                }
                else if(gamble2 < 10){
                lastSpawnedObject = Instantiate(obstacles[1], new Vector3(Random.Range(-4.2f, 4.2f), 0.9f, zPos + i), Quaternion.identity);
                lastSpawnedObject.transform.SetParent(lastSectionSpawned.transform);
                }
                else if(gamble2 < 13){
                lastSpawnedObject = Instantiate(obstacles[2], new Vector3(Random.Range(-4.2f, 4.2f), 1.5f, zPos + i), Quaternion.identity);
                lastSpawnedObject.transform.SetParent(lastSectionSpawned.transform);
                }
                else if(gamble2 < 19){
                lastSpawnedObject = Instantiate(obstacles[3], new Vector3(Random.Range(-4.2f, 4.2f), 0.7f, zPos + i), Quaternion.identity);
                lastSpawnedObject.transform.SetParent(lastSectionSpawned.transform);
                }
                else if(gamble2 < 20 && i - lastLogIndex > 3f){
                lastSpawnedObject = Instantiate(obstacles[4], new Vector3(0f, 1f, zPos + i), Quaternion.identity);
                lastSpawnedObject.transform.SetParent(lastSectionSpawned.transform);
                }
            }
        }
        
        
        float startIndex = zPos;
        int sequenceLength = 0;
        for(int i=0;i<3;i++){
            startIndex = startIndex + sequenceLength * 2f + Random.Range(1f,4f);
            sequenceLength = Random.Range(5,24);
            float xIndex = Random.Range(-3f, 3f);
            for(int j=0;j<sequenceLength;j++){
                lastSpawnedObject = Instantiate(coin, new Vector3(xIndex , 2, startIndex + j), Quaternion.Euler(90, 0, 0));
                lastSpawnedObject.transform.SetParent(lastSectionSpawned.transform);
            }
        }

        zPos += 50;
        yield return new WaitForSeconds(5f);

        if(index >= 6)
        Destroy(GameObject.Find($"Section {index - 5}"));

        creatingSection = false;
    }
}
