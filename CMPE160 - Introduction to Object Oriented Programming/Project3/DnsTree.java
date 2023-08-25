
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE
package question;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;
import java.util.Set;

/**
 * This class is a basic example of a DNS structure implemented as a tree.
 * A record can be added to the tree or removed if necessary.
 * It can be queried in order to get the IP address of the domain.
 *
 */
public class DnsTree{
	
	/**
	 * Root of the DnsTree
	 */
	private DnsNode root;
	
	/**
	 * Initializes the root.
	 */
	public DnsTree(){
		this.root = new DnsNode();
	}
	
	/**
	 * A domainName with given ipAddress is added to the tree. 
	 * If domain name already exists, only attach the given id.
	 * @param domainName
	 * @param ipAddress
	 */
	public void insertRecord(String domainName, String ipAddress){
       
	   DnsNode curr = this.root;
       
       String[] nodeNames = domainName.split("\\.");
		
       for(int i = nodeNames.length - 1 ;i >= 0; i--){

			if(!curr.childNodeList.containsKey(nodeNames[i])){
				curr.childNodeList.put(nodeNames[i], new DnsNode());
			}
			
			curr = curr.childNodeList.get(nodeNames[i]);
		}
         curr.ipAddresses.add(ipAddress);
         curr.validDomain = true;
	}
	/**
	 * Removes the domainName from the tree if it exists.
	 * @param domainName domainName of the
	 * @return If removed, returns true, therwise returns false.
	 */
	public boolean removeRecord(String domainName){
       
		DnsNode curr = this.root;
		
		String[] nodeNames = domainName.split("\\.");
		
		for(int i = nodeNames.length - 1 ;i >= 0; i--){
			
			if(!curr.childNodeList.containsKey(nodeNames[i])){
				return false;
			}
			
			// For leaf nodes. !!!!
			if(i==0 && curr.childNodeList.get(nodeNames[i]).childNodeList.isEmpty()){
				curr.childNodeList.remove(nodeNames[i]);
				return true;
			}
			
			curr = curr.childNodeList.get(nodeNames[i]);
		}
		
		if(curr.ipAddresses.isEmpty()){
			return false;
		}
		else{
		curr.ipAddresses.clear();
		curr.validDomain = false;
		return true;
		}
	}
	
	/**
	 * This method removes the ipAddress of the given domain.
	 * If it does not exist, do nothing.
	 * @param domainName domainName 
	 * @param ipAddress ipAddress
	 * @return If removed, returns true. Otherwise returns false.
	 */
	public boolean removeRecord(String domainName, String ipAddress){
		
		DnsNode root = this.root;
		
		String[] nodeNames = domainName.split("\\.");
		
		for(int i = nodeNames.length - 1 ;i >= 0; i--){
			
			if(!root.childNodeList.containsKey(nodeNames[i])){
				return false;
			}
			
			root = root.childNodeList.get(nodeNames[i]);
		}
		
		
		if(root.ipAddresses.isEmpty() || !root.ipAddresses.contains(ipAddress))
			return false;
		
		else if(root.ipAddresses.size() == 1){
			removeRecord(domainName);
		    return true;
		}
		
		else{
			root.ipAddresses.remove(ipAddress);
			return true;
		}
			
		
		
	}
	
	/**
	 * This method queries the domain and returns the next IP address of the domain 
	 * according to Round Robin mechanism explained in the description.
	 * @param domainName
	 * @return Next IP address
	 */
	public String queryDomain(String domainName){
		
		DnsNode curr = this.root;
		
		String[] nodeNames = domainName.split("\\.");
	  	
		for(int i = nodeNames.length -1 ; i >= 0 ; i--){
			
			if(!curr.childNodeList.containsKey(nodeNames[i])){
				return null;
			}
			
		  curr = curr.childNodeList.get(nodeNames[i]);
		}
	
		//Finds the ip according to round robin algorithm.
	  return findIp(curr,curr.attemptNo);
	  	
	}
	
	/**
	 * This method returns all domain names which have at least 1 IP address.
	 * In other words all the valid domain names.
	 * @return All valid domain names.
	 */
	public Map<String, Set<String>> getAllRecords(){
		
		Map<String, Set<String>> resultMap = new HashMap<String, Set<String>>();
		
          return getAllRecords(this.root, "" , resultMap);

	}

	private Map<String, Set<String>> getAllRecords(DnsNode root, String domainName, Map<String, Set<String>> resultMap) {
	    
        
		if(root.validDomain)
        	resultMap.put(domainName, root.ipAddresses);
		
		/* Not necessary, for each method for empty map does nothing.
		if(root.childNodeList.isEmpty())
			return resultMap;
			*/
		
		for(String name: root.childNodeList.keySet()){
			
		resultMap.putAll(getAllRecords(root.childNodeList.get(name), name + "." + domainName, resultMap));	
		}
       
		return resultMap;
	}

	private String findIp(DnsNode node, int attemptNo){
		
		attemptNo = attemptNo % node.ipAddresses.size();
		
		for(String ip: node.ipAddresses){
			if(attemptNo == 0){
				node.attemptNo++;
				return ip;
			}
			attemptNo--;
		}
		return null;
	}
}
//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

