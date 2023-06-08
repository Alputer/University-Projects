
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE
package question;

/**
 * This class represents a user of the computer. It has an IP address and a cache in his/her computer.
 * (S)he has access to the DNS via root field.
 *  
 * @author Alp Tuna
 */
public class Client{
	 
	  private class CachedContent{
		 /**
		  * Domain name of the content stored in the cache.
		  */
		 String domainName;
		 /**
		  * IP address of the content.
		  */
		 String ipAddress;
		 /**
		  * Number of the times local device has used the cached content without consulting DNS server.
		  * This information is kept in order to decide which cached content should be removed when the cache exceeds the size.
		  * Least used one will be removed.
		  */
		 int hitNo;
		 
		   CachedContent(String domainName, String ipAddress){
			  
			  this.domainName = domainName;
			  this.ipAddress = ipAddress;
			  this.hitNo = 0;
		  }
	 }
	 
	 /**
	  * This field makes it possible for the client to access the main DNS structure.
	  */
	 private DnsTree root;
	 
	 /**
	  * This field is like an ID of the client.
	  * Instead of an ID number, we deal with the client via his/her ipAddress.
	  */
	 private String ipAddress;
	 /**
	  * Just like cache in the computer has a limited size, this array also has a limited size.
	  * That makes the implementation more real world alike.
	  */
	 private CachedContent[] cacheList;
	 
	 /**
	  * Initializes the client object with given parameters.
	  * Its cacheList is a representation of the particular memory in the computer.
	  * Since it has a finite size, it is represented as an array. "10" is specific for this project.
	  * @param ipAddress ipAddress of the client.
	  * @param root Represents a Dns Tree.
	  */
	 public Client(String ipAddress, DnsTree root){
		 
		 this.root = root;
		 this.ipAddress = ipAddress;
		 this.cacheList = new CachedContent[10];
	 }
	 
	 /**
	  * This method returns the IP address of the given domain.
	  * If more than 1 IP address exists in the cache with that domain, record with minimum index will be returned.
	  * If it is not in the cache, it sends a query to the DNS.
	  * @param domainName
	  * @return IP address of the domain.
	  */
	 public String sendRequest(String domainName){
		
		 for(int i=0; i<10; i++){
			if(cacheList[i] != null && cacheList[i].domainName.equals(domainName)){
				
				cacheList[i].hitNo++;
				return cacheList[i].ipAddress;
			}
		}
		  
		 return root.queryDomain(domainName);
		 
	 }
	 /**
	  * This method adds the IP address returned from sendRequest method to the cacheList.
	  * It checks the availability of the cacheList and removes a record if necessary.
	  * @param domainName
	  * @param ipAddress
	  */
	 public void addToCache(String domainName, String ipAddress){
		 
		 for(int i=0;i<10;i++){
			 if(cacheList[i].domainName == domainName && cacheList[i].ipAddress == ipAddress)
				 return;
		 }
		 
		 CachedContent webSite = new CachedContent(domainName, ipAddress);
		 
		 for(int i=0;i<10;i++){
			if(cacheList[i] == null){
				cacheList[i] = webSite;
				return;
			}
		 }
			
		    int index = 0;
			int min = Integer.MAX_VALUE;
		 
		 for(int i=0;i<10;i++){
			 if(cacheList[i].hitNo < min){
			  min = cacheList[i].hitNo;
			  index = i;
		   }
		 }
		 
		 cacheList[index] = webSite;
		 return;
		 
	 }


}

//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

