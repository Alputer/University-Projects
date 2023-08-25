
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE
package question;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * This class represents a node in the DNS Tree.
 */
public class DnsNode{
	
	/**
	 * This map utilizes keeping the DnsNodes with their domain names.
	 * For example if the current node is ".uk", the key "ac" refers to the node ".ac.uk"
	 */
	 Map<String, DnsNode> childNodeList;
	
	/**
	 * This field keeps all the IP Addresses associated with this node.
	 * Note that a node can store more than one IP Address just as google.com has many servers worldwide.
	 */
	 Set<String> ipAddresses;
	 
	 /**
	  * This field is the number of attempts trying to access the IP addresses.
	  * It is needed for round robin algorithm.
	  */
	 int attemptNo;
	
	/**
	 * This field keeps the information whether the DnsNode is an intermediate node or a valid node.
	 * Valid nodes include IP Addresses, whereas intermediate nodes only utilize to reach the more complex domainNames. 
	 * Keep in mind that valid nodes does not have to be in the leaves.
	 */
	 boolean validDomain;
	
	/**
	 * Initializes the Node. 
	 * Since initially DnsNode does not contain any IP address, it is not a valid domain.
	 */
	public DnsNode(){
		this.childNodeList = new HashMap<String, DnsNode>();
		this.ipAddresses = new HashSet<String>();
		this.validDomain = false;
		this.attemptNo = 0;
		
	}
	
}




//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

