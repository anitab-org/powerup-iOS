/** Extension for checking null values for FMDB. */

extension FMResultSet {
    func isNull(forColumn: String) -> Bool {
        let value = self.object(forColumnName: forColumn)
        if let _ = value as? NSNull {
            return true
        } else {
            return (value == nil)
        }
        
    }
}
