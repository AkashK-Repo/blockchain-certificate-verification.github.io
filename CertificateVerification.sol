// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title CertificateVerification
 * @notice A simple, gas-light smart contract that lets an admin (e.g. an
 *         educational institution) issue tamper-proof certificates and lets
 *         anyone (employers, public) verify them instantly on-chain.
 */
contract CertificateVerification {

    address public admin;

    struct Certificate {
        string studentName;
        string courseName;
        string institution;
        uint256 issueDate;
        bool exists;
    }

    // certId => Certificate
    mapping(bytes32 => Certificate) private certificates;
    // certId => revoked?
    mapping(bytes32 => bool) public isRevoked;
    // keep a list of all issued cert IDs so the admin dashboard can list them
    bytes32[] public allCertificateIds;

    event CertificateIssued(
        bytes32 indexed certId,
        string studentName,
        string courseName,
        uint256 issueDate
    );
    event CertificateRevoked(bytes32 indexed certId);
    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender; // deployer becomes the first admin (the institution)
    }

    /**
     * @notice Issue a new certificate. Only the admin (institution) can call this.
     * @return certId A unique bytes32 identifier for this certificate.
     *         Give this ID to the certificate holder — it is what employers
     *         will type into the "Verify" box.
     */
    function issueCertificate(
        string memory _studentName,
        string memory _courseName,
        string memory _institution
    ) public onlyAdmin returns (bytes32 certId) {
        certId = keccak256(
            abi.encodePacked(
                _studentName,
                _courseName,
                _institution,
                block.timestamp,
                allCertificateIds.length
            )
        );

        certificates[certId] = Certificate({
            studentName: _studentName,
            courseName: _courseName,
            institution: _institution,
            issueDate: block.timestamp,
            exists: true
        });

        allCertificateIds.push(certId);

        emit CertificateIssued(certId, _studentName, _courseName, block.timestamp);
    }

    /**
     * @notice Anyone can call this — no wallet connection or gas needed if
     *         called as a view/call (the frontend uses a read-only call).
     */
    function verifyCertificate(bytes32 _certId)
        public
        view
        returns (
            bool valid,
            string memory studentName,
            string memory courseName,
            string memory institution,
            uint256 issueDate,
            bool revoked
        )
    {
        Certificate memory cert = certificates[_certId];
        if (!cert.exists) {
            return (false, "", "", "", 0, false);
        }
        return (
            true,
            cert.studentName,
            cert.courseName,
            cert.institution,
            cert.issueDate,
            isRevoked[_certId]
        );
    }

    /// @notice Admin can revoke a certificate (e.g. issued in error, or fraud found later).
    function revokeCertificate(bytes32 _certId) public onlyAdmin {
        require(certificates[_certId].exists, "Certificate does not exist");
        isRevoked[_certId] = true;
        emit CertificateRevoked(_certId);
    }

    /// @notice Transfer admin rights to a new address (e.g. institution changes wallet).
    function changeAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        emit AdminChanged(admin, _newAdmin);
        admin = _newAdmin;
    }

    /// @notice Total number of certificates ever issued.
    function totalCertificates() public view returns (uint256) {
        return allCertificateIds.length;
    }
}
