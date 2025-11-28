# class_name SceneRegistry; # Autoload conflict
extends Node;

var sceneBuckets: Dictionary[String, Array] = {};

func hasBucket(bucketName: String) -> bool:
    return sceneBuckets.has(bucketName);

func getBucket(bucketName: String) -> Array:
    if hasBucket(bucketName):
        return sceneBuckets[bucketName];
    else:
        return [];


func freeBucket(bucketName: String):
    if sceneBuckets.has(bucketName):
        for node in sceneBuckets[bucketName]:
            node.free();

func addToBucket(bucketName: String, node: Node) -> Node:
    if !sceneBuckets.has(bucketName):
        sceneBuckets[bucketName] = [];

    sceneBuckets[bucketName].push_back(node);

    return node;

func bucketAttachInstance(bucketName: String, parent: Node, instanceSoup):
    var node: Node;
    match typeof(instanceSoup):
        "Node": node = instanceSoup;
        "PackedScene": node = instanceSoup.instance();
        "String": node = load(instanceSoup).instance();

    addToBucket(bucketName, node);
    parent.add_child(node);


func setBucketProcessing(bucketName: String, enabled: bool):
    for node in getBucket(bucketName):
        node.process_mode = ProcessMode.PROCESS_MODE_INHERIT if enabled else ProcessMode.PROCESS_MODE_DISABLED;

func suspendBucket(bucketName: String):
    return setBucketProcessing(bucketName, false);

func resumeBucket(bucketName: String):
    return setBucketProcessing(bucketName, true);