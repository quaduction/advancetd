extends Node;

var sceneBuckets: Dictionary[String, Array] = {};

func hasBucket(bucketName: String) -> bool:
	return sceneBuckets.has(bucketName);

func getBucket(bucketName: String) -> Array:
	if hasBucket(bucketName):
		return sceneBuckets[bucketName];
	else:
		return [];

#
# Move nodes in/out of buckets
#

func freeBucket(bucketName: String):
	if sceneBuckets.has(bucketName):
		for node in sceneBuckets[bucketName]:
			node.free();
		sceneBuckets.erase(bucketName);

func addToBucket(bucketName: String, node: Node) -> Node:
	if !sceneBuckets.has(bucketName):
		sceneBuckets[bucketName] = [];

	sceneBuckets[bucketName].push_back(node);

	return node;

func bucketAttachInstance(bucketName: String, parent: Node, instanceSoup):
	var node := newNodeFromSoup(instanceSoup);

	addToBucket(bucketName, node);
	parent.add_child(node);

	return node;

#
# Pausing/resuming buckets
#

func setBucketProcessing(bucketName: String, enabled: bool):
	for node in getBucket(bucketName):
		setNodeProcessing(node, enabled);

func suspendBucket(bucketName: String):
	return setBucketProcessing(bucketName, false);

func resumeBucket(bucketName: String):
	return setBucketProcessing(bucketName, true);

# Final boss of pausing: unparenting them all
func detachBucket(bucketName: String):
	for node in getBucket(bucketName):
		unparentNode(node);


#
# Utils
#

func newNodeFromSoup(soup) -> Node:
	var node: Node;
	match type_string(typeof(soup)):
		"Node": node = soup;
		"PackedScene": node = soup.instantiate();
		"String": node = load(soup).instantiate();
	return node;

# Setting processing and pausing
func setNodeProcessing(node: Node, enabled: bool):
	node.process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED;

func pauseNode(node):
	setNodeProcessing(node, false);

func unpauseNode(node):
	setNodeProcessing(node, true);

# Unparenting
func unparentNode(node):
	var parent_node = node.get_parent();
	if parent_node != null:
		parent_node.remove_child(node);
