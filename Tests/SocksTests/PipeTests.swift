import XCTest
@testable import Socks

class PipeTests: XCTestCase {
    
    func testSendAndReceive() throws {
        let (read, write) = try TCPEstablishedSocket.pipe()
        let msg = "Hello Socket".makeBytes()
        try write.send(data: msg)
        let inMsg = try read.recv().string
        try read.close()
        try write.close()
        XCTAssertEqual(inMsg, "Hello Socket")
    }
    
    func testNoData() throws {
        let (read, write) = try TCPEstablishedSocket.pipe()
        try read.close()
        try write.close()
    }
    
    func testNoSIGPIPE() throws {
        
        let (read, write) = try TCPEstablishedSocket.pipe()
        try read.close()

        let msg = "Hello Socket".makeBytes()

        XCTAssertThrowsError(try write.send(data: msg)) { (error) in
            let err = error as! SocksError
            XCTAssertEqual(err.number, 32) //broken pipe
        }
        
        try write.close()
    }

}
