# KafkaPipelineExample
Simply sends a number from producer to topic "square" which squares the input.
Consumer for the "square" topic cubes the input and prints to stdout.

producer -> "square topic" -> n ^ 2 -> "cube topic" -> print n ^ 3
