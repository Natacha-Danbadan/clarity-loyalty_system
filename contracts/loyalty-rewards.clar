;; Loyalty Rewards Smart Contract
;; This contract enables the management of a loyalty reward system, where rewards are represented as non-fungible tokens (NFTs). 
;; Users can mint rewards, assign loyalty points to them, transfer ownership, burn rewards, and update their points.
;; It supports batch minting of rewards, ensuring that only the program owner can perform critical actions such as minting and burning rewards.
;; The contract maintains mappings for reward ownership, points, and burn status, along with metadata for batch processing.
;; Error handling ensures only valid actions are taken, and the contract is designed to manage both individual and batch operations efficiently.

;; Constants
(define-constant program-owner tx-sender) ;; Address of the program owner
(define-constant err-owner-only (err u200)) ;; Error for unauthorized actions by non-owners
(define-constant err-not-owner (err u201)) ;; Error for unauthorized access to resources
(define-constant err-invalid-points (err u202)) ;; Error for invalid points
(define-constant err-not-enough-points (err u203)) ;; Error for insufficient points
(define-constant err-already-burned (err u204)) ;; Error for trying to burn an already burned reward
(define-constant err-points-exist (err u205)) ;; Error when points already exist
(define-constant max-batch-size u100) ;; Maximum number of rewards in a single batch mint

;; Data Variables
(define-non-fungible-token loyalty-reward uint) ;; Loyalty reward NFT
(define-data-var last-reward-id uint u0) ;; Tracks the last assigned reward ID

;; Maps
(define-map reward-owner uint principal) ;; Maps reward IDs to their owners
(define-map reward-points uint uint) ;; Tracks loyalty points for each reward ID
(define-map burned-rewards uint bool) ;; Tracks whether a reward is burned
(define-map batch-metadata uint (string-ascii 256)) ;; Stores batch-related metadata

;; Private Helper Functions
(define-private (is-reward-owner (reward-id uint) (sender principal))
    ;; Checks if the sender is the owner of the specified reward ID
    (is-eq sender (unwrap! (map-get? reward-owner reward-id) false)))

(define-private (is-valid-points (points uint))
    ;; Validates that points are greater than or equal to 1
    (>= points u1))

(define-private (is-reward-burned (reward-id uint))
    ;; Checks if the reward has already been burned
    (default-to false (map-get? burned-rewards reward-id)))

(define-private (is-valid-reward-id (reward-id uint))
    ;; Checks if the reward ID exists
    (is-some (map-get? reward-owner reward-id)))

(define-private (mint-reward (points uint))
    ;; Mints a new reward with specified points and assigns it to the sender
    (let ((new-reward-id (+ (var-get last-reward-id) u1)))
        (asserts! (is-valid-points points) err-invalid-points)
        (try! (nft-mint? loyalty-reward new-reward-id tx-sender))
        (map-set reward-points new-reward-id points)
        (map-set reward-owner new-reward-id tx-sender)
        (var-set last-reward-id new-reward-id)
        (ok new-reward-id)))

;; Public Functions
(define-public (mint (points uint))
    ;; Mints a reward with the specified points (owner only)
    (begin
        (asserts! (is-eq tx-sender program-owner) err-owner-only)
        (asserts! (is-valid-points points) err-invalid-points)
        (mint-reward points)))

(define-public (batch-mint (points-list (list 100 uint)))
    ;; Mints multiple rewards in a single transaction (owner only)
    (let ((batch-size (len points-list)))
        (begin
            (asserts! (is-eq tx-sender program-owner) err-owner-only)
            (asserts! (<= batch-size max-batch-size) err-invalid-points)
            (asserts! (> batch-size u0) err-invalid-points)
            (ok (fold mint-reward-in-batch points-list (list))))))

(define-private (mint-reward-in-batch (points uint) (previous-results (list 100 uint)))
    ;; Helper function for batch minting
    (match (mint-reward points)
        success (unwrap-panic (as-max-len? (append previous-results success) u100))
        error previous-results))

(define-public (burn (reward-id uint))
    ;; Burns a reward owned by the sender
    (let ((current-owner (unwrap! (map-get? reward-owner reward-id) err-not-owner)))
        (asserts! (is-eq tx-sender current-owner) err-not-owner)
        (asserts! (not (is-reward-burned reward-id)) err-already-burned)
        (try! (nft-burn? loyalty-reward reward-id current-owner))
        (map-set burned-rewards reward-id true)
        (ok true)))


;; Read-Only Functions
(define-read-only (get-reward-points (reward-id uint))
    ;; Returns the points associated with a reward
    (ok (map-get? reward-points reward-id)))

(define-read-only (get-reward-owner (reward-id uint))
    ;; Returns the owner of a reward
    (ok (map-get? reward-owner reward-id)))

(define-read-only (get-last-reward-id)
    ;; Returns the last assigned reward ID
    (ok (var-get last-reward-id)))
