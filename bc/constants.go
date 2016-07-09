package bc

const (
	// UFIs for Registry
	UFI_Registry_Address = "90d47c2fadde66b9fcbd0b3f3f29280776864f44"
	// WhoHoldsPatentFor(bytes32 hash) -> address
	UFI_Registry_WhoHoldsPatentFor = "90d47c2fadde66b9fcbd0b3f3f29280776864f440201e25340?0000000000000"
	// RevokeEntity(bytes32 target, bytes content) ->
	UFI_Registry_RevokeEntity = "90d47c2fadde66b9fcbd0b3f3f29280776864f44101b61064500000000000000"
	// DChains(bytes32 ) -> bytes,uint8,uint256
	UFI_Registry_DChains = "90d47c2fadde66b9fcbd0b3f3f29280776864f4439da84524051100000000000"
	// Entities(bytes32 ) -> bytes,uint8,uint256
	UFI_Registry_Entities = "90d47c2fadde66b9fcbd0b3f3f29280776864f4445bc46934051100000000000"
	// DOTFromVK(bytes32 , uint256 ) -> bytes32
	UFI_Registry_DOTFromVK = "90d47c2fadde66b9fcbd0b3f3f29280776864f444d0c2d294104000000000000"
	// PatentDuration() -> uint256
	UFI_Registry_PatentDuration = "90d47c2fadde66b9fcbd0b3f3f29280776864f44670224f20100000000000000"
	// AddRevocationBounty(bytes32 hash) ->
	UFI_Registry_AddRevocationBounty = "90d47c2fadde66b9fcbd0b3f3f29280776864f4474fe92474000000000000000"
	// CheckEntity(bytes32 vk) ->
	UFI_Registry_CheckEntity = "90d47c2fadde66b9fcbd0b3f3f29280776864f44ae8efe464000000000000000"
	// PatentExpiry(bytes32 ) -> uint256
	UFI_Registry_PatentExpiry = "90d47c2fadde66b9fcbd0b3f3f29280776864f44af0733c44010000000000000"
	// AddChain(bytes content) ->
	UFI_Registry_AddChain = "90d47c2fadde66b9fcbd0b3f3f29280776864f44b4b3b0285000000000000000"
	// SetPatentProperties(uint256 price, uint256 duration) ->
	UFI_Registry_SetPatentProperties = "90d47c2fadde66b9fcbd0b3f3f29280776864f44b5fa20441100000000000000"
	// RevocationBounties(bytes32 ) -> uint256
	UFI_Registry_RevocationBounties = "90d47c2fadde66b9fcbd0b3f3f29280776864f44bbe201014010000000000000"
	// Retire() ->
	UFI_Registry_Retire = "90d47c2fadde66b9fcbd0b3f3f29280776864f44be63c8ca0000000000000000"
	// RevokeDOT(bytes32 target, bytes content) ->
	UFI_Registry_RevokeDOT = "90d47c2fadde66b9fcbd0b3f3f29280776864f44c8bdc0c74500000000000000"
	// CheckDOT(bytes32 hash) ->
	UFI_Registry_CheckDOT = "90d47c2fadde66b9fcbd0b3f3f29280776864f44cc0e24e14000000000000000"
	// Patents(bytes32 ) -> address
	UFI_Registry_Patents = "90d47c2fadde66b9fcbd0b3f3f29280776864f44d5c9b86d40?0000000000000"
	// PatentPrice() -> uint256
	UFI_Registry_PatentPrice = "90d47c2fadde66b9fcbd0b3f3f29280776864f44dd195adf0100000000000000"
	// DOTs(bytes32 ) -> bytes,uint8,uint256
	UFI_Registry_DOTs = "90d47c2fadde66b9fcbd0b3f3f29280776864f44e220d60b4051100000000000"
	// ClosePatent(bytes32 hash) ->
	UFI_Registry_ClosePatent = "90d47c2fadde66b9fcbd0b3f3f29280776864f44eedbd7eb4000000000000000"
	// NewPatent(bytes32 hash) ->
	UFI_Registry_NewPatent = "90d47c2fadde66b9fcbd0b3f3f29280776864f44f5d00ccf4000000000000000"
	// AddDOT(bytes content) ->
	UFI_Registry_AddDOT = "90d47c2fadde66b9fcbd0b3f3f29280776864f44f73cc97c5000000000000000"
	// admin() -> address
	UFI_Registry_admin = "90d47c2fadde66b9fcbd0b3f3f29280776864f44f851a4400?00000000000000"
	// AddEntity(bytes content) ->
	UFI_Registry_AddEntity = "90d47c2fadde66b9fcbd0b3f3f29280776864f44fd3b34e65000000000000000"
	// EVENT  NewDOT(bytes32 hash, bytes object)
	EventSig_Registry_NewDOT = "23e2201ae7a60da1894143cf38ff932197d41ea3c0ac56ba07508e94dd97bd5f"
	// EVENT  NewEntity(bytes32 vk, bytes object)
	EventSig_Registry_NewEntity = "dc3ccc0c791e17af72d7a1d84e19a437d6df93a9cdbfb14be6a77aaddab5379c"
	// EVENT  NewDChain(bytes32 hash, bytes object)
	EventSig_Registry_NewDChain = "c5139e309869ce33b308069ea347af9c36b5acf4153211330c5263b09bbe4f87"
	// EVENT  NewDOTRevocation(bytes32 hash, bytes object)
	EventSig_Registry_NewDOTRevocation = "d43aee07c367b5b7b99663d2f73a8a1e88a2ee92d3438d046987354941183d7d"
	// EVENT  NewEntityRevocation(bytes32 vk, bytes object)
	EventSig_Registry_NewEntityRevocation = "f9d5df120d569da6793b5f00adc41887535dbfe0c8db954160d5b3e41f037407"
	// EVENT  NewRevocationBounty(bytes32 key, uint256 newValue)
	EventSig_Registry_NewRevocationBounty = "b432cc2d9d9f8ab188e4f2bfa21932d4f503d3615de7f3f4e30f642c401d04c2"
	// EVENT  Patent(bytes32 hash)
	EventSig_Registry_Patent = "e4def3e3d51780d99b55a5b68fdf27e18bbd00a3d716d10d3f007d55a4cda340"

	// UFIs for Affinity
	UFI_Affinity_Address = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc06"
	// OfferRouting(bytes32 drvk, bytes32 nsvk, uint256 drnonce, bytes sig) ->
	UFI_Affinity_OfferRouting = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc062671b61d4415000000000000"
	// AffinityOffers(bytes32 , bytes32 ) -> uint256
	UFI_Affinity_AffinityOffers = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc064257802c4401000000000000"
	// RetractRoutingDR(bytes32 drvk, bytes32 nsvk, uint256 drnonce, bytes sig) ->
	UFI_Affinity_RetractRoutingDR = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc064517bd424415000000000000"
	// RetractRoutingNS(bytes32 nsvk, bytes32 drvk, uint256 nsnonce, bytes sig) ->
	UFI_Affinity_RetractRoutingNS = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc067b40b2914415000000000000"
	// DRNonces(bytes32 ) -> uint256
	UFI_Affinity_DRNonces = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc0697313f504010000000000000"
	// SetDesignatedRouterSRV(bytes32 drvk, uint256 drnonce, bytes srv, bytes sig) ->
	UFI_Affinity_SetDesignatedRouterSRV = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc06976160fa4155000000000000"
	// AcceptRouting(bytes32 nsvk, bytes32 drvk, uint256 nsnonce, bytes sig) ->
	UFI_Affinity_AcceptRouting = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc06a46a12194415000000000000"
	// DesignatedRouterFor(bytes32 ) -> bytes32
	UFI_Affinity_DesignatedRouterFor = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc06af5265a34040000000000000"
	// DRSRV(bytes32 ) -> bytes
	UFI_Affinity_DRSRV = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc06b2c2037b4050000000000000"
	// NSNonces(bytes32 ) -> uint256
	UFI_Affinity_NSNonces = "61a21a55aa92a72434f6e5b93cd22b3a5eaccc06fe7d84474010000000000000"
	// EVENT  NewAffinityOffer(bytes32 drvk, bytes32 nsvk)
	EventSig_Affinity_NewAffinityOffer = "5d5fe87b8f68fb29f061a899a66a01861209d0d9c7cf05f791ae4de248f21b38"
	// EVENT  NewDesignatedRouter(bytes32 nsvk, bytes32 drvk)
	EventSig_Affinity_NewDesignatedRouter = "a7dc341d1527a5adcc38fbdb058eee4e51d698d46618581e3eef50607e5fa7f5"
	// EVENT  NewSRV(bytes32 drvk, bytes srv)
	EventSig_Affinity_NewSRV = "7e2249f88d598d3772dd9d6b40d3637810b779f5b2baa141e3e1045abebabf21"
)
