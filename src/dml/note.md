Note
- When we run sparkSQL we should set dynamic parition insert to true, so insert overwrite only delete current parition.
- Otherwise all data would be cleaned up.
