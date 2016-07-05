package bwe

import "fmt"

//These are messages that are not generated by the clients.
// -status from message
// -find/ls response
// they are not signed because they are "from" the router
// and the transport is secure. These terminate at the router
// so the client never sees this "framing".
// i.e c->A->B, this message would be from B to A. c only sees
// the contents of the message, not the frame.

type BWStatus struct {
	Code int
	Msg  string
}

func (s *BWStatus) Error() string {
	return fmt.Sprintf("[%03d] %s", s.Code, s.Msg)
}

func C(code int) *BWStatus {
	return &BWStatus{Code: code, Msg: "See code"}
}
func M(code int, msg string) *BWStatus {
	return &BWStatus{Code: code, Msg: msg}
}

//This is basically an assert to catch places where we are not
//properly annotating underlying errors
func AsBW(err error) *BWStatus {
	bwerr, ok := err.(*BWStatus)
	if !ok {
		panic(err)
	}
	return bwerr
}

func WrapC(code int, err error) *BWStatus {
	return &BWStatus{Code: code, Msg: err.Error()}
}
func WrapM(code int, msg string, err error) *BWStatus {
	return &BWStatus{Code: code, Msg: msg + ": " + err.Error()}
}

const (
	Unchecked      = 0
	Okay           = 200
	OkayAsResolved = 201
	Unresolvable   = 401
	InvalidDOT     = 402
	InvalidSig     = 403
	TTLExpired     = 404
	BadPermissions = 405
	//In Anarchy we are assuming that all messages are delivered on a channel
	//that matches the origin VK of the messages. This indicates a mismatch
	//of that assumption
	OriginVKMismatch = 406
	//Using an ALL dchain but no origin RO
	NoOrigin = 407
	BadURI   = 408
	//Returned if you try to publish to a wildcard
	BadOperation      = 409
	MVKMismatch       = 410
	MalformedMessage  = 411
	AffinityMismatch  = 412
	PeerError         = 413
	ExpiredDOT        = 414
	ExpiredEntity     = 415
	RevokedDOT        = 416
	RevokedEntity     = 417
	ChainOriginNotMVK = 418
	InvalidEntity     = 419
	//Returned when a permission RO is used where an access RO is required
	NotAccessRO = 420
	//Returned when a DChain has a DOT whose src is not the previous dst
	BadLink = 421
	//Returned when a URI is invalid after being constrained by DOTs
	OverconstrainedURI = 422
	//Returned if you attempt to send a message without having an entity
	NoEntity = 423
	//Returned for invalid OOB commands
	InvalidOOBCommand = 424
	//Returned for malformed OOB commands
	MalformedOOBCommand = 425
	//Returned when a chain could not be built
	ChainBuildFailed = 426
	//Returned when a hash or vk is invalid base64 encoding
	InvalidCoding    = 427
	ResolutionFailed = 428
	//Called when a chain build was given invalid params
	BadChainBuildParams = 429
	//Called when a hash or vk is not a 32 byte slice
	InvalidSlice = 430
	//Called when a view creation expression is bad or a view does not exist
	BadView = 431
	//A view encountered a suboperation error
	ViewError        = 432
	UnsubscribeError = 433

	//Called when an expired message is verified
	ExpiredMessage = 434

	//The revocation is not an authority for its target
	InvalidRevocation = 435

	//The 500 series are chain interaction errors
	RegistryEntityResolutionFailed = 500
	RegistryDOTResolutionFailed    = 501
	RegistryChainResolutionFailed  = 502
	//Could be revocation or expiry
	RegistryEntityInvalid = 503
	RegistryDOTInvalid    = 504
	RegistryChainInvalid  = 505

	BlockChainGenericError = 506
	//Generic error when invoking UFIs
	UFIInvocationError = 507
	//If a UFI is badly encoded
	InvalidUFI = 508

	InvalidAccountNumber = 509

	TransactionTimeout             = 510
	TransactionConfirmationTimeout = 511

	ChainStale = 512

	UnresolvedAlias = 513
	AliasExists     = 514
	AliasError      = 515

	// Returned when you try revoke an unpublished object
	NotRevokable = 516
)
